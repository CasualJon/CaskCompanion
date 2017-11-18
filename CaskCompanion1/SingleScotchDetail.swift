//
//  SingleScotchDetail.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/3/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

/////////////////////////////////////////////////////////////////////////////////////
//  Full Scotch Struct
/////////////////////////////////////////////////////////////////////////////////////
struct FULL_SCOTCH {
    // From Scotch Table
    var name: String!
    var img: String!
    var age: String!
    var abv: String!
    var mjScore: String!
    var distiller: String!
    
    // From Distiller Table
    var distillerPhonetic: String!
    var pronounce: String!
    
    //  From Location Table (joined w/ Distiller)
    var region: String!
    var district: String!
    
    //  From UserStats Table
    var myScore: String!
    
    //  From assorted Scotch_% Tables
    var colorChars: [String]!
    var colorExample: String!
    var noseChars: [String]!
    var bodyChars: [String]!
    var palateChars: [String]!
    var finishChars: [String]!
}

class SingleScotchDetail: UIViewController {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    public var scotchKey: String!
    private var singleMalt: FULL_SCOTCH!
    private let noText = "???"
    private let none = "None"
    private let noRating = "Rate It!"
    private let NAS = "NAS"
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    
    //  Mutable Labels on the Scotch Detail Page
    @IBOutlet weak var sdImage: UIImageView!
    @IBOutlet weak var sdName: UILabel!
    @IBOutlet weak var sdAgeABV: UILabel!
    @IBOutlet weak var sdDistillerPhonetic: UILabel!
    @IBOutlet weak var sdRegion: UILabel!
    @IBOutlet weak var sdDistrict: UILabel!
    @IBOutlet weak var sdMJScore: UILabel!
    @IBOutlet weak var sdColorChars: UILabel!
    @IBOutlet weak var sdNoseChars: UILabel!
    @IBOutlet weak var sdBodyChars: UILabel!
    @IBOutlet weak var sdPalateChars: UILabel!
    @IBOutlet weak var sdFinishChars: UILabel!
    @IBOutlet weak var audioButtonOutlet: UIButton!
    @IBOutlet weak var distillerButtonOutlet: UIButton!
    @IBOutlet weak var myScoreButtonOutlet: UIButton!
    
    //  Buttons on the Scotch Detail Page
    @IBAction func sdDistillerButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DistillerDetail") as! SingleDistillerDetail
        nextVC.distillerKey = singleMalt.distiller
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func sdDistillerPronounceButton(_ sender: UIButton) {
        //  No Title to send to basic debug method
        WhiskyDo.shared.playSound(proAudioName: singleMalt.pronounce!)
    }
    
    
    @IBAction func sdMyScoreButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        if singleMalt.myScore != nil && !singleMalt.myScore.isEmpty {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "IndividualRatingsTable") as! MyScotchRatingsVC
            nextVC.scotchName = sdName.text
            nextVC.scotchAgeAbv = sdAgeABV.text
            nextVC.scotchImg = sdImage.image
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RateAScotch") as! RateScotchVC
            nextVC.scotchName = sdName.text
            nextVC.scotchAgeAbv = sdAgeABV.text
            nextVC.scotchImage = sdImage.image
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Setup the Struct
        singleMalt = FULL_SCOTCH()
        singleMalt.name = scotchKey
        
        if singleMalt.name != nil && !singleMalt.name.isEmpty {
            DBManager.shared.populateScotchDetail(whatScotch: scotchKey, whatStruct: &singleMalt)
        }
        
        //------------------------NAME & IMAGE------------------------
        sdName.text = singleMalt.name
        if singleMalt.img == nil || singleMalt.img.isEmpty || singleMalt.img == none {
            sdImage.image = #imageLiteral(resourceName: "UNKNOWN")
        }
//TODO - update code here to reference the String brought into singleMalt.img as the picture
        
        //------------------------AGE & ABV------------------------
        var ageAbvCombo = ""
        if singleMalt.age != nil && !singleMalt.age.isEmpty{
            ageAbvCombo = singleMalt.age!
            ageAbvCombo += " years"
        }
        else {
            ageAbvCombo = NAS
        }
        if singleMalt.abv != nil && !singleMalt.abv.isEmpty {
            ageAbvCombo += ", "
            ageAbvCombo += singleMalt.abv
            ageAbvCombo += "%"
        }
        sdAgeABV.text = ageAbvCombo
        
        //------------------------DISTILLER------------------------
        if singleMalt.distiller != nil && !singleMalt.distiller.isEmpty {
            distillerButtonOutlet.setTitle(singleMalt.distiller, for: UIControlState.normal)
        } else {
            distillerButtonOutlet.setTitle(noText, for: UIControlState.normal)
        }
        
        //------------------------PHONETIC SPELL------------------------
        if singleMalt.distillerPhonetic != nil && !singleMalt.distillerPhonetic.isEmpty {
            var howToSay = "("
            howToSay += singleMalt.distillerPhonetic
            howToSay += ")"
            sdDistillerPhonetic.text = howToSay
        } else {
            sdDistillerPhonetic.text = noText
        }
        
        //------------------------REGION------------------------
        if singleMalt.region != nil && !singleMalt.region.isEmpty {
            sdRegion.text = singleMalt.region
        } else {
            sdRegion.text = noText
        }
        
        //------------------------DISTRICT------------------------
        if singleMalt.district != nil && !singleMalt.district.isEmpty {
            sdDistrict.text = singleMalt.district
        } else {
            sdDistrict.text = noText
        }
        
        //------------------------MJ SCORE------------------------
        if singleMalt.mjScore != nil && !singleMalt.mjScore.isEmpty {
            sdMJScore.text = String(singleMalt.mjScore)
        } else {
            sdMJScore.text = none
        }
        
        //------------------------MY SCORE------------------------
        if singleMalt.myScore == nil || singleMalt.myScore.isEmpty {
            myScoreButtonOutlet.setTitle(noRating, for: UIControlState.normal)
        } else {
            myScoreButtonOutlet.setTitle(singleMalt.myScore, for: UIControlState.normal)
        }
        
        //------------------------PRONOUNCIATION AUDIO------------------------
        if singleMalt.pronounce == nil || singleMalt.pronounce.isEmpty || singleMalt.pronounce == none {
            //  Remove the button if there is no data file to play
            audioButtonOutlet.removeFromSuperview()
        }
        
        //------------------------COLOR------------------------
        if singleMalt.colorChars != nil && singleMalt.colorChars.count > 0 {
            var colors = ""
            for c in singleMalt.colorChars {
                colors += c
                colors += ", "
            }
            let colorSubRange = colors.index(colors.endIndex, offsetBy: -2) ..< colors.endIndex
            colors.removeSubrange(colorSubRange)
            sdColorChars.text = colors
        } else {
            sdColorChars.text = noText
        }
        
        if singleMalt.colorExample != nil && !singleMalt.colorExample.isEmpty {
            sdColorChars.backgroundColor = UIColor(patternImage: UIImage(named: singleMalt.colorExample)!)
        }
        
        //------------------------NOSE------------------------
        if singleMalt.noseChars != nil && singleMalt.noseChars.count > 0 {
            var noses = ""
            for n in singleMalt.noseChars {
                noses += n
                noses += ", "
            }
            let nosesSubRange = noses.index(noses.endIndex, offsetBy: -2) ..< noses.endIndex
            noses.removeSubrange(nosesSubRange)
            sdNoseChars.text = noses
        } else {
            sdNoseChars.text = noText
        }
        
        //------------------------BODY------------------------
        if singleMalt.bodyChars != nil && singleMalt.bodyChars.count > 0 {
            var bodies = ""
            for b in singleMalt.bodyChars {
                bodies += b
                bodies += ", "
            }
            let bodiesSubRange = bodies.index(bodies.endIndex, offsetBy: -2) ..< bodies.endIndex
            bodies.removeSubrange(bodiesSubRange)
            sdBodyChars.text = bodies
        } else {
            sdBodyChars.text = noText
        }
        
        //------------------------PALATE------------------------
        if singleMalt.palateChars != nil && singleMalt.palateChars.count > 0 {
            var palates = ""
            for p in singleMalt.palateChars {
                palates += p
                palates += ", "
            }
            let palatesSubRange = palates.index(palates.endIndex, offsetBy: -2) ..< palates.endIndex
            palates.removeSubrange(palatesSubRange)
            sdPalateChars.text = palates
        } else {
            sdPalateChars.text = noText
        }
        
        //------------------------FINISH------------------------
        if singleMalt.finishChars != nil && singleMalt.finishChars.count > 0 {
            var finishes = ""
            for f in singleMalt.finishChars {
                finishes += f
                finishes += ", "
            }
            let finishesSubRange = finishes.index(finishes.endIndex, offsetBy: -2) ..< finishes.endIndex
            finishes.removeSubrange(finishesSubRange)
            sdFinishChars.text = finishes
        } else {
            sdFinishChars.text = noText
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DBManager.shared.updateScotchAvgScore(singleMalt: &singleMalt!)
        if singleMalt.myScore == nil || singleMalt.myScore.isEmpty {
            myScoreButtonOutlet.setTitle(noRating, for: UIControlState.normal)
        } else {
            myScoreButtonOutlet.setTitle(singleMalt.myScore, for: UIControlState.normal)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
