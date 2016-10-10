//
//  Dispatcher.swift
//  Muttley
//
//  Created by Zolo on 10/10/16.
//  Copyright © 2016 Zolo. All rights reserved.
//

import Foundation


class Dispatcher {
    
    static var queue = [String: [(Data?, MuttleyError?)->Void]]()
    static var memory = Memory()
    
    static func fetch(url: String, completion: @escaping (Data?, MuttleyError?)->Void) {
        
        // 1| Check the cache for the data
        if let data = memory[url] as? Data {
            completion(data, nil)
            return
        }
        
        
        // 2| Add the completion to the queue
        if queue.keys.contains(url) {
            queue[url]!.append(completion)
            return
        } else {
            queue[url] = [completion]
        }
        
        
        // 3| Create the URL
        guard let weburl = URL(string: url) else {
            completion(nil, .invalidURL)
            return
        }
        
        
        // 4| Load
        Loader.load(url: weburl) { (data, error) in
            
            // Completion
            let completions = self.queue[url]
            completions?.forEach({ (completion) in
                completion(data, error)
            })
            
            
            // Cache
            memory[url] = data as NSData?
            
            
            // Clear the queue
            self.queue.removeValue(forKey: url)
        }
    }
    
    
    static func clean() {
        memory.removeAllObjects()
    }
}