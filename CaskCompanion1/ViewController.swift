//
//  ViewController.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 7/15/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
//TODO - consider making a singleton... this would save memory and allow calling elsewhere.  
//Since, frankly, I'm not doing great with MVC...
    private let scotch = WhiskyDo ()
    
    
    /*
    JDC - implementation of Cask Companion begins here.
    Project is intended as an iOS10 application built in XCode 8 with Swift 3 and SQLite3.
    Goals include providing details about actively produced single malt scotches, their 
    distilleries, the owners of those distilleries, and prvide a system for individual 
    user ratings, which subsequently enables recommendations to the user based on previously 
    recorded preferences.  Additional features are meant to include helpful, educational 
    material about single malt Scotch Whisky.  
    
    While there may be some inaccuracies in the data because of available source material 
    online, every effort was made to record and provide accurate details everywhere possible.
     
    Initially undertaken as a class project for CS564 at the University of Wisconsin - Madison.
     
    Enjoy responsibly.
    */
    

    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //  FIND Scotch Selection
    @IBAction func findScotch(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
    
    //  RATE Scotch Selection
    @IBAction func rateScotch(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }

    @IBAction func getRecommendation(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
    
    @IBAction func openGlossary(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
    
    @IBAction func openWhisky101(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
    
    @IBAction func openFeedback(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
	
}

