//
//  MyStatsVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/7/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

/////////////////////////////////////////////////////////////////////////////////////
//  Class Fields
/////////////////////////////////////////////////////////////////////////////////////
struct pairsOfStrings {
    var firstStr: String!
    var secondStr: String!
}

class MyStatsVC: UIViewController {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    let numRatingSuffix = " ratings:"
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var numSingleMaltsOutlet: UILabel!
    @IBOutlet weak var numDistilleriesOutlet: UILabel!
    @IBOutlet weak var numRegionsOutlet: UILabel!
    @IBOutlet weak var mostSampledScotchNum: UILabel!
    @IBOutlet weak var mostSampledScotchList: UILabel!
    @IBOutlet weak var mostSampledDistillerNum: UILabel!
    @IBOutlet weak var mostSampledDistillerList: UILabel!
    @IBOutlet weak var mostSampledRegionsNum: UILabel!
    @IBOutlet weak var mostSampledRegionsList: UILabel!
    @IBOutlet weak var topRatedScotchOutlet: UILabel!
    @IBOutlet weak var topScotchScoreOutlet: UILabel!
    @IBOutlet weak var topRatedDistillerOutlet: UILabel!
    @IBOutlet weak var topDistillerScoreOutlet: UILabel!
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateHowManyTried()
        populateMostSampled()
        populateTops()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //  NAME:   populateHowManyTried()
    //  USAGE:  Method to update the outlets for number of scotches, distilleries, and regions tried
    //  PARAMS: NA
    //  RETURN: Void
    //  BUGS:   None
    func populateHowManyTried() {
        if let scotchNum = DBManager.shared.numScotchesRated() {
            numSingleMaltsOutlet.text = scotchNum
        } else {
            numSingleMaltsOutlet.text = "0"
        }
        
        if let distillerNum = DBManager.shared.numDistilleriesSampled() {
            numDistilleriesOutlet.text = distillerNum
        } else {
            numDistilleriesOutlet.text = "0"
        }
        
        if let regionsNum = DBManager.shared.numRegionsSampled() {
            numRegionsOutlet.text = regionsNum
        } else {
            numRegionsOutlet.text = "0"
        }
    }
    
    
    //  NAME:   populateMostSampled()
    //  USAGE:  Method to update the outlets for most sampled scotches, distilleries, and regions
    //  PARAMS: NA
    //  RETURN: Void
    //  BUGS:   None
    func populateMostSampled() {
        var scotchCount: [pairsOfStrings]!
        var distillerCount: [pairsOfStrings]!
        var regionCount: [pairsOfStrings]!
        
        DBManager.shared.mostSampledItems(scotchCount: &scotchCount, distillerCount: &distillerCount, regionCount: &regionCount)
        
        if scotchCount != nil {
            var num = scotchCount[0].firstStr!
            num += numRatingSuffix
            
            mostSampledScotchNum.text = num
            
            var names = ""
            for i in 0 ..< scotchCount.count {
                names += scotchCount[i].secondStr
                names += ", "
            }
            let namesSubRange = names.index(names.endIndex, offsetBy: -2) ..< names.endIndex
            names.removeSubrange(namesSubRange)
            mostSampledScotchList.text = names
        }
        
        if distillerCount != nil {
            var num = distillerCount[0].firstStr!
            num += numRatingSuffix
            
            mostSampledDistillerNum.text = num
            
            var names = ""
            for i in 0 ..< distillerCount.count {
                names += distillerCount[i].secondStr
                names += ", "
            }
            let namesSubRange = names.index(names.endIndex, offsetBy: -2) ..< names.endIndex
            names.removeSubrange(namesSubRange)
            mostSampledDistillerList.text = names
        }
        
        if regionCount != nil {
            var num = regionCount[0].firstStr!
            num += numRatingSuffix
            
            mostSampledRegionsNum.text = num
            
            var names = ""
            for i in 0 ..< regionCount.count {
                names += regionCount[i].secondStr
                names += ", "
            }
            let namesSubRange = names.index(names.endIndex, offsetBy: -2) ..< names.endIndex
            names.removeSubrange(namesSubRange)
            mostSampledRegionsList.text = names
        }
    }
    
    
    
    //  NAME:   populateTops()
    //  USAGE:  Method to update the outlets for top rated scotch & distiller
    //  PARAMS: NA
    //  RETURN: Void
    //  BUGS:   None
    func populateTops() {
        var myTopScotch: pairsOfStrings!
        var myTopDistiller: pairsOfStrings!
        
        DBManager.shared.populateTops(topScotch: &myTopScotch, topDistiller: &myTopDistiller)
        if myTopScotch != nil {
            topScotchScoreOutlet.text = myTopScotch.firstStr!
            topRatedScotchOutlet.text = myTopScotch.secondStr!
        }
        
        if myTopDistiller != nil {
            topDistillerScoreOutlet.text = myTopDistiller.firstStr!
            topRatedDistillerOutlet.text = myTopDistiller.secondStr!
        }
    }
}
