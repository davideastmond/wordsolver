//
//  Public Delcarations.swift
//  WordSolver
//
//  Created by David Eastmond on 2016-10-08.
//  Copyright © 2016 David Eastmond. All rights reserved.
//

import Foundation

// MARK: Top-level objects and variables
let g_MasterList =  try! WordList(minCharCount: wordListDimension.dimensionMinCharCount.rawValue, maxCharCount: wordListDimension.dimensionMaxCharCount.rawValue)

// MARK: Top-level enumerations and types
public enum wordListDimension : Int {
    case dimensionMinCharCount = 3
    case dimensionMaxCharCount = 8
}

public enum validCharString : String {
    case alphaWithSlash = "ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz"
    case alphaNoSlash = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    case numericNoSlash = "1234567890"
    case numericWithSlash = "1234567890/"
    
}
public let Slash : Character = "/"

// MARK: Top-level functions and subs available to the entire app
public func checkForValidChars (charsToCheck : String, validCharString : String) -> Bool {
    var targetChars : Int = 0
    var validCharCount : Int = 0
    
    targetChars = charsToCheck.count // set the target, which is the length of the character string
    
    for eachCharToBeChecked in charsToCheck {
        for eachCharToBeComparedAgainst in validCharString {
            if eachCharToBeChecked == eachCharToBeComparedAgainst {
                validCharCount += 1
            }
        }
    }
    
    // Final Evaluation
    if validCharCount == targetChars {
        return true // Good: meets the requirement
    } else {
        return false // Bad: there is an invalid character in the filter string
    }
}
