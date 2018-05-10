//
//  ViewController.swift
//  WordSolver
//
//  Created by David Eastmond on 2016-09-19.
//  Copyright © 2016 David Eastmond. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

// MARK: Properties
    @IBOutlet weak var txtBlockWorldListText: UITextView!
    
    
    @IBOutlet weak var cmdReloadWL: UIButton!
    @IBOutlet weak var txtFilter: UITextField!
    @IBOutlet weak var progIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cmdDoBasicFilter: UIButton!
    @IBOutlet weak var cmdFilterStringPattern: UIButton!
    @IBOutlet weak var cmdExcludeMultiIndividualChars: UIButton!
    @IBOutlet weak var cmdReturnStringFilter: UIButton!
    @IBOutlet weak var cmdIncludeMultiINDV: UIButton!
    @IBOutlet weak var cmdExcludeCharsAtPos: UIButton!
    @IBOutlet weak var cmdClear: UIButton!
    
    @IBOutlet weak var cmdKeyboardBack: UIButton!
    
    @IBOutlet weak var txtViewLetterCount: UITextView!
   
    @IBOutlet weak var cmdPreSufx: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the tableView
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Animate the progress
        progIndicator.startAnimating()
        txtFilter.isEnabled = false // Disable the filter
        //MARK: Run-Time design
        // Create a border around the UITextView
        txtBlockWorldListText.layer.cornerRadius = 2
        txtBlockWorldListText.layer.borderColor = UIColor.black.cgColor
        txtBlockWorldListText.layer.borderWidth = 1
        
        //Create a border around the UITextField
        txtFilter.layer.cornerRadius = 2
        txtFilter.layer.borderColor = UIColor.black.cgColor
        txtFilter.layer.borderWidth = 2
        
        //hide keyboard when tapp off
       
        //Create a border around the doBasicFilter Button
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let myQueue = DispatchQueue(label: "LoadWordListFromFile")
        var myLoadString = ""
        myQueue.async {
            myLoadString = g_MasterList.LoadWordListFromFile()
            DispatchQueue.main.async { self.txtBlockWorldListText.text = myLoadString
            // Stop the animating
                self.progIndicator.stopAnimating()
                self.txtFilter.isEnabled = true
                self.updateLetterCountData(updateControl: self.txtViewLetterCount)} //Enable the txtFilter text block so user can start to filter the word
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cmdDoBasicFilter_Click(_ sender: AnyObject) {
        // This is the basic filter, which shall be enclosed in a do-try-catch block
        
        do {
            try g_MasterList.doBasicFilter(filter: txtFilter.text!) // Try out the filter
            txtBlockWorldListText.text = g_MasterList.updateWordListTextBox()
            updateLetterCountData(updateControl: txtViewLetterCount)
            
        } catch WordList.WordListError.noResultsFound {
            showAlert(messageTitle: "doBasicFilter", messageBody: "No results found")
        
        } catch WordList.WordListError.invalidFilterString {
            showAlert(messageTitle: "doBasicFilter", messageBody: "Invalid filter string")
        
        } catch {
            showAlert(messageTitle: "doBasicFilter", messageBody: "There was a problem in 'doBasicFilter'")
        }
    }
    @IBAction func cmdExcludeMultiChars(_ sender: AnyObject) {
        do {
            try g_MasterList.excludeMultiIndividualChars(filter: txtFilter.text!) // Try out the filter
                txtBlockWorldListText.text = g_MasterList.updateWordListTextBox()
                updateLetterCountData(updateControl: txtViewLetterCount)

        } catch WordList.WordListError.noResultsFound {
            showAlert(messageTitle: "Exclude Multi Chars", messageBody: "No results found")
            
        } catch WordList.WordListError.invalidFilterString {
            showAlert(messageTitle: "Exclude Multi Chars", messageBody: "Invalid filter string")
            
        } catch {
            showAlert(messageTitle: "Exclude Multi Chars", messageBody: "There was a problem in 'doBasicFilter'")
        }
    }
    @IBAction func cmdFilterStringPattern_Click(_ sender: AnyObject) {
        
            // Filter for the string pattern
            do {
                try g_MasterList.excludeWordsWithStringPattern(filter: txtFilter.text!)
                txtBlockWorldListText.text = g_MasterList.updateWordListTextBox()
                updateLetterCountData(updateControl: txtViewLetterCount)

                //self.tableView.reloadData()
            } catch  WordList.WordListError.noResultsFound {
                showAlert(messageTitle: "Exclude String Pattern", messageBody: "No results found")
            } catch WordList.WordListError.invalidFilterString {
                showAlert(messageTitle: "Exclude String Pattern", messageBody: "Invalid filter string")
                
            } catch {
                showAlert(messageTitle: "Exclude String Pattern", messageBody: "There was a problem in 'FilterStringPattern'")
            }
    }
    
    @IBAction func cmdReloadWL_Click(_ sender: AnyObject) {
        
        // Reload the wordlist
        
        // Animate the progress
        progIndicator.startAnimating()
        txtFilter.isEnabled = false // Disable the filter
        txtBlockWorldListText.text = "loading word list"
        
        // Start an async queue and load the list fresh
        let myQueue = DispatchQueue(label: "ReLoadWordListFromFile")
        var myLoadString = ""
        
        myQueue.async {
            myLoadString = g_MasterList.LoadWordListFromFile()
            DispatchQueue.main.async { self.txtBlockWorldListText.text = myLoadString
                // Stop the animating
                self.progIndicator.stopAnimating()
                self.txtFilter.isEnabled = true
                self.updateLetterCountData(updateControl: self.txtViewLetterCount)} //Enable the txtFilter text block so user can start to filter the word
        }
        //self.tableView.reloadData()

    }
    @IBAction func cmdReturnStringFilter_Click(_ sender: AnyObject) {
        // Filter for the string pattern
        do {
            try g_MasterList.returnWordsWithStringPattern(filter: txtFilter.text!)
            txtBlockWorldListText.text = g_MasterList.updateWordListTextBox()
            updateLetterCountData(updateControl: txtViewLetterCount)

            //self.tableView.reloadData()
        } catch  WordList.WordListError.noResultsFound {
            showAlert(messageTitle: "Return String Pattern", messageBody: "No results found")
        } catch WordList.WordListError.invalidFilterString {
            showAlert(messageTitle: "Return String Pattern", messageBody: "Invalid filter string")
            
        } catch {
            showAlert(messageTitle: "Return String Pattern", messageBody: "There was a problem in 'return string filter'")
        }
    }
    
    @IBAction func cmdExcludeCharsAtPos_Click(_ sender: AnyObject) {
        // Filter for string pattern
        
        do {
            try g_MasterList.excludeCharsAtPosition(filter: txtFilter.text!)
            txtBlockWorldListText.text = g_MasterList.updateWordListTextBox()
            updateLetterCountData(updateControl: txtViewLetterCount)

            //self.tableView.reloadData()
        } catch  WordList.WordListError.noResultsFound {
            showAlert(messageTitle: "Exclude Char at Pos", messageBody: "No results found")
        } catch WordList.WordListError.invalidFilterString {
            showAlert(messageTitle: "Exclude Char at Pos", messageBody: "Invalid filter string")
            
        } catch {
            showAlert(messageTitle: "Exclude Char at Pos", messageBody: "There was a problem in 'Exclude Char at Pos'")
        }
    }
    @IBAction func cmdIncludeMultiINDV_Click(_ sender: AnyObject) {
        // Filter for the string pattern
        do {
            try g_MasterList.includeMultiIndividualChars(filter: txtFilter.text!)
            txtBlockWorldListText.text = g_MasterList.updateWordListTextBox()
            updateLetterCountData(updateControl: txtViewLetterCount)

            //self.tableView.reloadData()
        } catch  WordList.WordListError.noResultsFound {
            showAlert(messageTitle: "Include Multi Individual Chars", messageBody: "No results found")
        } catch WordList.WordListError.invalidFilterString {
            showAlert(messageTitle: "Include Multi Individual Chars", messageBody: "Invalid filter string")
            
        } catch {
            showAlert(messageTitle: "Include Multi Individual Chars", messageBody: "There was a problem in 'Include Multi individual chars'")
        }

    }
    
    @IBAction func cmdPreSufx_Tap(_ sender: Any) {
        do {
            try g_MasterList.beginsWithEndsWith(filter: txtFilter.text!)
            txtBlockWorldListText.text = g_MasterList.updateWordListTextBox()
            updateLetterCountData(updateControl: txtViewLetterCount)
        } catch  WordList.WordListError.noResultsFound {
            showAlert(messageTitle: "Prefix / Suffix", messageBody: "No results found")
        } catch WordList.WordListError.invalidFilterString {
            showAlert(messageTitle: "Prefix / Suffix", messageBody: "Invalid filter string")
            
        } catch {
            showAlert(messageTitle: "Prefix / Suffix", messageBody: "There was a problem in 'Prefix-Suffix'")
        }
    }
    @IBAction func cmdDismissKeyboard_Tap(_ sender: AnyObject) {
        // Dismiss keyboard
        view.endEditing(true)
        
    }
    @IBAction func cmdClear_Click(_ sender: AnyObject) {
        txtFilter.text = "" // Clear
    }
    private func updateLetterCountData (updateControl : UITextView) {
        updateControl.text = "" // Clear the box
        let letterCountData = g_MasterList.getLetterCount()
    
        //print("count is" + String(letterCountData.count.count), " lettersCount is" +  String(letterCountData.letter.count))
        
        for index in 0...letterCountData.letter.count - 1 {
            
            updateControl.text.append(letterCountData.letter[index] + " = " + String(letterCountData.count[index]) + "\n")
        }
        
    }
    private func showAlert(messageTitle : String, messageBody : String) {
        let alertBox = UIAlertController(title: messageTitle, message: messageBody, preferredStyle: .alert)
        
        let alertBoxDefaultAction = UIAlertAction(title: "OK", style: .default,handler: nil)
        
        //Add the action
        alertBox.addAction(alertBoxDefaultAction)
        
        self.present(alertBox, animated: true, completion: nil)
    }
    
}

