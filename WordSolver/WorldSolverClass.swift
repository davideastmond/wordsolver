//
//  WorldSolverClass.swift
//  WordSolver
//
//  Created by David Eastmond on 2016-09-20.
//  Copyright © 2016 David Eastmond. All rights reserved.
//  The WordList Class

import Foundation
import UIKit


open class WordList {
    // Properties
    
    var sortedWordList = [String]() //Holds the list of sorted words
    var MaxWordFilterLength : Int = 8 // Default is (8)
    var MinWordFilterLength : Int = 2 // Default is (2)
    var totalWordCount : Int = 0
    var LetterCount = [Int] (repeatElement(0, count: 26)) // Holds the amount of each letter of the alphabet in all words
    var largestWord : Int = 0
    
    // Initializer / Constructor
    
    init (minCharCount : Int, maxCharCount : Int) throws {
        
        if maxCharCount >= 2 && minCharCount >= 2 {
            if minCharCount < maxCharCount {
                self.MaxWordFilterLength = maxCharCount // Set the MaxWordFilterLength
                self.MinWordFilterLength = minCharCount // MiniWordFilterLength
            } else {
                throw WordListError.badInitParameter
                
            }
        } else {
            throw WordListError.badInitParameter
        }
        
    }
    
    public enum WordListError : Error {
        case badInitParameter
        case invalidFilterString
        case noResultsFound
    }
    public func LoadWordListFromFile() -> String {
        //Read the embedded db file
        
        let path = Bundle.main.path(forResource: "wordlist", ofType: "db")
        var inputString : String?
        
        do {
            inputString =  try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch {
            
        }
        
        var TempWord : String = ""
        var FinalString : String = ""
        
        //Clear the sorted words list
        self.sortedWordList.removeAll() //Clear
        
        for eachChar in (inputString)! {
            if String(eachChar) != " " {
                TempWord.append(eachChar)
            } else {
                if TempWord.count <= MaxWordFilterLength {
                    FinalString.append(TempWord + " ")
                    
                    //Load the word into the sorted word list
                    
                    self.sortedWordList.append(TempWord)
                    
                    // Clear the Word
                    TempWord = ""
                } else {
                    TempWord = ""
                }
            }
        }
        self.totalWordCount = self.sortedWordList.count
        doLetterCount()
        getLargestWordCharCount()
        //print("total word count is \(totalWordCount)")
        return FinalString
    }
    
    public func updateWordListTextBox() -> String {
        //* This function takes the sorted word list and outputs it so it can be displayed 
        var finalOutputString : String = ""
        
        for eachWord in self.sortedWordList {
            finalOutputString.append(eachWord + " ")
        }
        return finalOutputString
    }
    
    public func doBasicFilter(filter : String) throws {
        let rawFilter = filter.uppercased() // Ensure the string is uppercased
        
        
        // - Ensure there are no spaces in the filter string
        let mySpace = " "
        
        // If there is a space in the filter string
        if rawFilter.range(of: mySpace) != nil {
            throw WordList.WordListError.invalidFilterString
        }
        
        // make sure there are valid characters in the string
        if checkForValidChars(charsToCheck: rawFilter, validCharString: validCharString.alphaWithSlash.rawValue) == false {
            throw WordList.WordListError.invalidFilterString
        }
        
        var chkSum : Int = 0
        var chkSumTarget : Int = 0
        var fnd = false
        let tempWordList = try WordList(minCharCount: wordListDimension.dimensionMinCharCount.rawValue, maxCharCount: wordListDimension.dimensionMaxCharCount.rawValue)

                
        
        // Calculate the CheckSumTarget
        for eachChar in rawFilter
        {
            if eachChar != "/" {
                chkSumTarget += 1 // Increment
            }
        }
        // We'll need to cycle through the WordList object's sorted word list and stop at everyword that matches the targetlength
        //print("Sorted Word List is: \(sortedWordList)")
        for eachItem in sortedWordList {
            if eachItem.count == rawFilter.count {
                //String length matches
                for (filterCharIndex, filterChar) in rawFilter.enumerated() {
                    if filterChar != "/" {
                        for (aSecondCharIndex, aSecondChar) in eachItem.enumerated() {
                            if aSecondChar == filterChar && aSecondCharIndex == filterCharIndex {
                                chkSum += 1
                            }
                        }
                    }
                }
            }
            
                        //Evaluate the checkSum
            if chkSum == chkSumTarget {
                tempWordList.sortedWordList.append(eachItem)
                fnd = true
                chkSum = 0
            } else {
                chkSum = 0 // Reset
            }
        }
        if fnd == true {
            self.sortedWordList.removeAll() // Clear
            self.sortedWordList = tempWordList.sortedWordList
            self.totalWordCount = self.sortedWordList.count
            doLetterCount()
            getLargestWordCharCount()
            
        } else {
            throw WordListError.noResultsFound
        }
    }
    public func excludeWordsWithStringPattern(filter : String) throws {
        // This function will filter out any word that contains the specified filter string pattern 
        
        // First check if the filter string pattern is valid
        if !checkForValidChars(charsToCheck: filter, validCharString: validCharString.alphaNoSlash.rawValue) {
            throw WordListError.invalidFilterString
        }
        var hasFoundMatchingPattern : Bool = false
        let tempWordList = try WordList(minCharCount: wordListDimension.dimensionMinCharCount.rawValue, maxCharCount: wordListDimension.dimensionMaxCharCount.rawValue)

        // Cycle through the word list
        for eachWord in self.sortedWordList {
            if eachWord.range(of: filter) != nil {
                // do nothing
            } else {
                hasFoundMatchingPattern = true //Toggle
                tempWordList.sortedWordList.append(eachWord)
            }
        }
        
        // If found a matching pattern
        if hasFoundMatchingPattern {
            self.sortedWordList.removeAll() // Clear
            self.sortedWordList = tempWordList.sortedWordList
            self.totalWordCount = self.sortedWordList.count
            doLetterCount()

        } else {
            throw WordListError.noResultsFound
        }
    }
    public func returnWordsWithStringPattern (filter : String) throws {
         // This function will only return words that match the filter pattern
        
        // First check if the filter string pattern is valid
        if !checkForValidChars(charsToCheck: filter, validCharString: validCharString.alphaNoSlash.rawValue) {
            throw WordListError.invalidFilterString
        }
        
        let tempWordList = try WordList(minCharCount: wordListDimension.dimensionMinCharCount.rawValue, maxCharCount: wordListDimension.dimensionMaxCharCount.rawValue)
        var isFnd : Bool = false
        
        //Cycle through the wordList
        for eachWord in self.sortedWordList {
            if eachWord.range(of: filter) != nil {// Found a match!
                isFnd = true
                tempWordList.sortedWordList.append(eachWord)
                
            }
        }
        
        // Evaluate
        if isFnd == true {
            //Update the list
            self.sortedWordList.removeAll()
            self.sortedWordList = tempWordList.sortedWordList
            doLetterCount()
        } else {
            throw WordListError.noResultsFound
        }

    }
    public func excludeMultiIndividualChars (filter : String) throws {
        
        // This function will eliminate any word that contains any Char in the filter string
        // First check if the filter string pattern is valid
        if !checkForValidChars(charsToCheck: filter, validCharString: validCharString.alphaNoSlash.rawValue) {
            throw WordListError.invalidFilterString
        }
        
        var fnd : Bool = false
        var toggle : Bool = false
        let tempWordList = try WordList(minCharCount: wordListDimension.dimensionMinCharCount.rawValue, maxCharCount: wordListDimension.dimensionMaxCharCount.rawValue)
        
        for eachWord in self.sortedWordList {
            for eachFilterChar in filter{
                if eachWord.range(of: String(eachFilterChar)) != nil {
                    // do nothing
                    fnd = true
                    toggle = true
                    
                    continue
                } else {
                    // found something
                   
                }
            }
            if toggle == true {
                toggle = false
                continue
            } else {
                tempWordList.sortedWordList.append(eachWord)
                toggle = false
            }
        }
        //
        if fnd == true {
            self.sortedWordList.removeAll() // Clear
            self.sortedWordList = tempWordList.sortedWordList
            self.totalWordCount = self.sortedWordList.count
            doLetterCount()
            
        } else {
            throw WordListError.noResultsFound
        }

    }
    public func includeMultiIndividualChars (filter : String) throws {
        // This function will only include words that contains every char in the filter
        let tempWordList = try WordList(minCharCount: wordListDimension.dimensionMinCharCount.rawValue, maxCharCount: wordListDimension.dimensionMaxCharCount.rawValue)
        
        // Check if the filter string pattern is valid
        if !checkForValidChars(charsToCheck: filter, validCharString: validCharString.alphaNoSlash.rawValue) {
            throw WordListError.invalidFilterString
        }
        
        let goalCharCount = filter.count // Sets our goal for the amount of valid characters to pass the test
        var charCount : Int = 0 // Keeps track of how many character matches
        var fnd : Bool = false
        
        for eachWord in self.sortedWordList {
            for eachFilterChar in filter {
                if eachWord.range(of: String(eachFilterChar)) != nil {
                    charCount += 1 // increase the count
                }
            }
        //  Evaluate
            if charCount == goalCharCount {
                charCount = 0 // Reset
                
                // Word is valid, add to the templist
                tempWordList.sortedWordList.append(eachWord)
                fnd = true // Toggle the found
            } else {
                // Reset the count
                charCount = 0
            }
        
        }
        
        if fnd == true {
            self.sortedWordList.removeAll() // Clear
            self.sortedWordList = tempWordList.sortedWordList
            self.totalWordCount = self.sortedWordList.count
            doLetterCount()
        } else {
            throw WordListError.noResultsFound
        }

    }
    public func excludeCharsAtPosition (filter : String) throws {
        /* This function will exclude characters at the specified character index position (needs slashes)
         For example such as: a///t indicates:
         Look for five-letter words whose character index 1 is a, and character index 5 is "t" and exclude that word from the list */
        
        // make sure the filter string is good
        
        // Check if the filter string pattern is valid
        if !checkForValidChars(charsToCheck: filter, validCharString: validCharString.alphaWithSlash.rawValue) {
            throw WordListError.invalidFilterString
        }
        
        var fnd : Bool = false
        let tempWordList = try WordList(minCharCount: wordListDimension.dimensionMinCharCount.rawValue, maxCharCount: wordListDimension.dimensionMaxCharCount.rawValue)
        let targetValidCharCount = getNumberOfActualCharactersToCheck(filter: filter)
        var actualValidCharCount : Int = 0
        
        
        for eachWord in self.sortedWordList {
            // We will only evaluate words that match the filter length
            
            if eachWord.count == filter.count {
                for (sortedWordCharIndex, sortedWordCharValue) in eachWord.enumerated() {
                    for (filterCharIndex, filterCharValue) in filter.enumerated() {
                        if sortedWordCharIndex == filterCharIndex && sortedWordCharValue == filterCharValue {
                            // Chalk one up to match
                            actualValidCharCount += 1
                        }
                    }
                }
                // Evaluate what we've found in terms of character matches
                if actualValidCharCount == targetValidCharCount {
                    actualValidCharCount = 0 // Reset
                    // Add the word to our temporary list
                    tempWordList.sortedWordList.append(eachWord)
                    fnd = true
                }
            } else { // No word match
                continue
            }
        }
        
        // Evaluate
        if fnd == true { // a match was found
            self.sortedWordList.removeAll() // Clear
            self.sortedWordList = tempWordList.sortedWordList
            self.totalWordCount = self.sortedWordList.count
            doLetterCount()
        } else {
            throw WordListError.noResultsFound
        }
    }
    public func beginsWithEndsWith(filter : String) throws {
        // This function will return words that begin with a string ie. str/
        // or ends wtih ie. /ion
        
        // First determine if it's a ends with
        var adjustedFilter : String = ""
        var fndValidInfo : Bool = false
        var fndValidFilter : Bool = false
        var typeFilter : String  = ""
        
        let tempWordList = try WordList(minCharCount: wordListDimension.dimensionMinCharCount.rawValue, maxCharCount: wordListDimension.dimensionMaxCharCount.rawValue)
        
        // Make sure the filter string isn't too large
        if filter.count > self.largestWord {
            // Filter string is too big
            throw WordListError.invalidFilterString
        }
        
        // Modify the filter
        if filter[filter.startIndex] == "/" {
            typeFilter = "sfx"
            fndValidFilter = true
            adjustedFilter = filter
            adjustedFilter.remove(at: adjustedFilter.startIndex) // Remove the slash
            
        } else if filter[filter.index(before: filter.endIndex)] == "/" {
            typeFilter = "pfx"
            fndValidFilter = true
            adjustedFilter = filter
            adjustedFilter.remove(at: filter.index(before: filter.endIndex))
            
        } else {
            throw WordListError.invalidFilterString
        }
        
        if fndValidFilter == true {
            if typeFilter == "sfx" {
                // Do a search for an affix
                for eachWord in self.sortedWordList {
                    if eachWord.hasSuffix(adjustedFilter) == true {
                        tempWordList.sortedWordList.append(eachWord)
                        fndValidInfo = true
                    }
                }
                
            } else if typeFilter == "pfx" {
                // Do a search for a suffix
                for eachWord in self.sortedWordList {
                    if eachWord.hasPrefix(adjustedFilter) == true {
                        tempWordList.sortedWordList.append(eachWord)
                        fndValidInfo = true
                    }
                }
            }
            
        } else {
            throw WordListError.invalidFilterString
        }
        if !fndValidInfo {
            throw WordListError.noResultsFound
        } else {
            // update the word list and count
            self.sortedWordList.removeAll() // Clear
            self.sortedWordList = tempWordList.sortedWordList
            self.totalWordCount = self.sortedWordList.count
            doLetterCount()
        }
        
    }
    private func getNumberOfActualCharactersToCheck(filter : String) -> Int {
        // This takes a filter string with slashes and returns the amount of actual characters that need to be checked
        var CharCount : Int = 0
        
        for eachChar in filter {
            if eachChar != "/" {
                CharCount += 1
            }
        }
        return CharCount
        
    }

    private func clearLetterCount() {
        // Clears
        for index in 0...self.LetterCount.count - 1 {
            LetterCount[index] = 0 // Reset the counts
        }
    }
    private func doLetterCount() {
        //Counts/tallies the occurence of each alphabet letter
        
        //clear the letter count
        clearLetterCount()
        
        for eachWord in self.sortedWordList {
            for eachCharacter in eachWord.utf8 {
                self.LetterCount[Int(eachCharacter - 65)] += 1
            }
        }
    }
    public func getLetterCount() -> (letter: [String], count: [Int]) {
        var letterArray =  [String]()
        var letterCountArray = [Int]()
        
        for (LCIndex, LCValue) in self.LetterCount.enumerated() {
            if LCValue > 0 {
                // We'll only count things that are greater than zero
                letterArray.append(String(Character(UnicodeScalar(LCIndex + 65)!)))
                letterCountArray.append(LCValue)
                
            }
            
        }
        //print (letterArray, letterCountArray)
        return (letterArray, letterCountArray)
    }
    private func getLargestWordCharCount () {
        // This will calculate the length (character count) of the largest word
        var myTempLargest : Int = 0
        
        for index in 0...sortedWordList.count - 1 {
            if sortedWordList[index].count > myTempLargest {
                myTempLargest = sortedWordList[index].count
            }
            
        }
        
        self.largestWord = myTempLargest
        print ("Largest word is \(self.largestWord)")
    }
}
