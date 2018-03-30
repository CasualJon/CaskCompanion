//
//  RecommendationsVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/8/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

class RecommendationsVC: UIViewController {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    private var palate: pairsOfStrings!
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var topPalateCharOutlet: UILabel!
    @IBOutlet weak var topPalateScoreOutlet: UILabel!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBManager.shared.preferredPalateChar(topPalate: &palate)
        
        if palate != nil {
            let num = Float(palate.firstStr!)
            let displayNum = String(format: "%.1f", num!)
            topPalateScoreOutlet.text = displayNum
            topPalateCharOutlet.text = palate.secondStr
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
