//
//  MuttleyError.swift
//  Muttley
//
//  Created by Zolo on 10/8/16.
//  Copyright © 2016 Zolo. All rights reserved.
//

import Foundation

public enum MuttleyError {
    case invalidURL
    case timeOut
    case networkError(statusCode: Int, localizedDescription: String)
    case cancelled
    case parseError(String)
}
