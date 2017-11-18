//
//  FindRateScotchVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/1/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

class FindRateScotchVC: UIViewController, UITextFieldDelegate {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    private var searchFor: String!

    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var userInput: UITextField!
    
    @IBAction func browseByRegion(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchByRegion") as! SearchByRegionVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    @IBAction func browseByName(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
    
    @IBAction func browseByDistiller(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
    
    @IBAction func browseByOwner(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userInput.text != nil {
            searchFor = userInput.text!
            WhiskyDo.shared.detailToConsole(option: "User search data = \(searchFor!)")
        }
        userInput.resignFirstResponder()
        
        if searchFor != nil {
            //  Trim off whitespace and then punctuation characters... Assumption is made here that a user
            //  isn't trying to search for something like "  . . ...   . . .!" if they do, they'll just 
            //  get nothing back in the search results shown in the pushed SelectScotchFromVC
            searchFor = searchFor.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
            searchFor = searchFor.trimmingCharacters(in: NSCharacterSet.punctuationCharacters)
            
            if searchFor.isEmpty {
                userInput.text = nil
                return false
            }
            
            userInput.text = nil
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectScotchLanding") as! SelectScotchFromVC
            nextVC.searchFor = searchFor
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
