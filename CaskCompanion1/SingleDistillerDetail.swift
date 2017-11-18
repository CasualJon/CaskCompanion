//
//  SingleDistillerDetail.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/3/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

/////////////////////////////////////////////////////////////////////////////////////
//  Full Distiller Struct
/////////////////////////////////////////////////////////////////////////////////////
struct FULL_DISTILLER {
    //  From Distiller table
    var name: String!
    var image: String!
    var founded: String!
    var owner: String!
    var proText: String!
    var proAudio: String!
    var longitude: Double!
    var latitude: Double!
    var washStillCnt: String!
    var spiritStillCnt: String!
    var waterSource: String!
    var capacity: String!
    var wikipediaLink: String!
    var websiteLink: String!
    var gaelicMeaning: String!
    var historyNotes: String!
    
    //  From Location table
    var region: String!
    var district: String!
}

class SingleDistillerDetail: UIViewController {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    public var distillerKey: String!
    private var theDistillery: FULL_DISTILLER!
    
    private var leftLinkTarget: String!
    private var rightLinkTarget: String!
    
    private let founded = "Founded: "
    private let none = "None"
    private let notKnown = "Unknown"
    private let yesWikipediaLink = "Wikipedia Link"
    private let yesWebsiteLink = "Website Link"
    private let noText = "???"
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var distillerNameOutlet: UILabel!
    @IBOutlet weak var distillerImageOutlet: UIImageView!
    @IBOutlet weak var distillerProTextOutlet: UILabel!
    @IBOutlet weak var distillerRegionDistOutlet: UIButton!
    @IBOutlet weak var distillerFoundedOutlet: UILabel!
    @IBOutlet weak var distillerGaelicMeaningOutlet: UILabel!
    @IBOutlet weak var distillerWashStillsOutlet: UILabel!
    @IBOutlet weak var distillerSpiritStillsOutlet: UILabel!
    @IBOutlet weak var distillerCapacityOutlet: UILabel!
    @IBOutlet weak var distillerWaterSourceOutlet: UILabel!
    @IBOutlet weak var distillerHistoryOutlet: UITextView!
    @IBOutlet weak var distillerOwnerOutlet: UIButton!
    @IBOutlet weak var distillerLeftWebsiteLink: UIButton!
    @IBOutlet weak var distillerRightWebsiteLink: UIButton!
    @IBOutlet weak var distillerAudioOutlet: UIButton!
    @IBOutlet weak var showScotchesOutlet: UIButton!
    
    @IBAction func proAudioButton(_ sender: UIButton) {
        //  No current title to send to basid debugger
        WhiskyDo.shared.playSound(proAudioName: theDistillery.proAudio!)
    }
    
    @IBAction func regionDistrictButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DistillerMap") as! DistillerMappingVC
        nextVC.lat = theDistillery.latitude
        nextVC.long = theDistillery.longitude
        nextVC.distiller = theDistillery.name
        nextVC.scotchRegion = theDistillery.region
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func showScotchesButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ScotchesFromDistiller") as! ScotchesFromDistillerVC
        nextVC.distillerName = theDistillery.name
        nextVC.distillerImage = distillerImageOutlet.image
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func leftWebsiteButton(_ sender: UIButton) {
        if distillerLeftWebsiteLink.title(for: UIControlState.normal) == nil {
            return
        }
        else {
            if let leftURL = URL(string: leftLinkTarget) {
                UIApplication.shared.open(leftURL, options: [:], completionHandler: nil)
            }
        }
        
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }

    @IBAction func rightWebsiteButton(_ sender: UIButton) {
        if distillerRightWebsiteLink.title(for: UIControlState.normal) == nil {
            return
        }
        else {
            if let rightURL = URL(string: rightLinkTarget) {
                UIApplication.shared.open(rightURL, options: [:], completionHandler: nil)
            }
        }
        
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
    }
    
    
    @IBAction func ownerButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "OwnerDetail") as! SingleOwnerDetail
        nextVC.ownerKey = theDistillery.owner
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup the Struct, then call the query to populate full details
        theDistillery = FULL_DISTILLER()
        theDistillery.name = distillerKey
        DBManager.shared.populateDistillerDetail(theDistiller: &theDistillery)
        
        //------------------------NAME & IMAGE------------------------
        if theDistillery.name != nil && !theDistillery.name.isEmpty {
            distillerNameOutlet.text = theDistillery.name
        } else {
            distillerNameOutlet.text = noText
        }
        
        if theDistillery.image == nil || theDistillery.name.isEmpty || theDistillery.image == none {
            distillerImageOutlet.image = #imageLiteral(resourceName: "DALLAS_DHU")
            distillerImageOutlet.contentMode = .scaleToFill
//TODO - Update Setting Proper Image for the Distller
        }
        
        //------------------------PRONUNCIATION AUDIO & TEXT------------------------
        if theDistillery.proAudio == nil || theDistillery.proAudio.isEmpty || theDistillery.proAudio == none {
            //  Remove the button if there is no data file to play
            distillerAudioOutlet.removeFromSuperview()
        }
        
        var pronunciation = ""
        if theDistillery.proText != nil && !theDistillery.proText.isEmpty {
            pronunciation += "("
            pronunciation += theDistillery.proText
            pronunciation += ")"
        }
        
        distillerProTextOutlet.text = pronunciation
        
        //------------------------REGION & DISTRICT------------------------
        var regionDistrict = ""
        if theDistillery.region != nil && !theDistillery.region.isEmpty {
            regionDistrict += theDistillery.region
            regionDistrict += ", "
        }
        
        if theDistillery.district != nil && !theDistillery.district.isEmpty {
            regionDistrict += theDistillery.district
        }
        
        distillerRegionDistOutlet.setTitle(regionDistrict, for: UIControlState.normal)
        
        //------------------------FOUNDED------------------------
        var founding = ""
        if theDistillery.founded != nil && !theDistillery.founded.isEmpty {
            founding += founded
            founding += theDistillery.founded
        }
        
        distillerFoundedOutlet.text = founding
        
        //------------------------GAELIC MEANING------------------------
        if theDistillery.gaelicMeaning != nil && !theDistillery.gaelicMeaning.isEmpty {
            distillerGaelicMeaningOutlet.text = theDistillery.gaelicMeaning
        } else {
            distillerGaelicMeaningOutlet.text = notKnown
        }
        
        //------------------------STILLS & CAPACITY------------------------
        if theDistillery.washStillCnt != nil && !theDistillery.washStillCnt.isEmpty {
            distillerWashStillsOutlet.text = theDistillery.washStillCnt
        } else {
            distillerWashStillsOutlet.text = ""
        }
        
        if theDistillery.spiritStillCnt != nil && !theDistillery.spiritStillCnt.isEmpty {
            distillerSpiritStillsOutlet.text = theDistillery.spiritStillCnt
        } else {
            distillerSpiritStillsOutlet.text = ""
        }
        
        if theDistillery.capacity != nil && !theDistillery.capacity.isEmpty {
            distillerCapacityOutlet.text = theDistillery.capacity
        } else {
            distillerCapacityOutlet.text = ""
        }
        
        //------------------------WATER SOURCE------------------------
        if theDistillery.waterSource != nil && !theDistillery.waterSource.isEmpty {
            distillerWaterSourceOutlet.text = theDistillery.waterSource
        } else {
            distillerWaterSourceOutlet.text = ""
        }
        
        //------------------------HISTORY NOTES------------------------
        if theDistillery.historyNotes != nil && !theDistillery.historyNotes.isEmpty {
            distillerHistoryOutlet.text = theDistillery.historyNotes
        } else {
            distillerHistoryOutlet.text = noText
        }
        
        //------------------------WIKIPEDIA & WEBSITE------------------------
        let wikiLink = theDistillery.wikipediaLink != nil && !theDistillery.wikipediaLink.isEmpty
        let websiteLink = theDistillery.websiteLink != nil && !theDistillery.websiteLink.isEmpty
        
        //  If both links are available
        if wikiLink && websiteLink {
            distillerLeftWebsiteLink.setTitle(yesWikipediaLink, for: UIControlState.normal)
            leftLinkTarget = theDistillery.wikipediaLink
            distillerRightWebsiteLink.setTitle(yesWebsiteLink, for: UIControlState.normal)
            rightLinkTarget = theDistillery.websiteLink
        }
            
        //  If only wikipedia link available
        else if wikiLink && !websiteLink {
            distillerLeftWebsiteLink.setTitle(yesWikipediaLink, for: UIControlState.normal)
            leftLinkTarget = theDistillery.wikipediaLink
            
            distillerRightWebsiteLink.setTitle(nil, for: UIControlState.normal)
            distillerRightWebsiteLink.removeFromSuperview()
        }
            
        //  If only website link available
        else if !wikiLink && websiteLink {
            distillerLeftWebsiteLink.setTitle(yesWebsiteLink, for: UIControlState.normal)
            leftLinkTarget = theDistillery.websiteLink
            
            distillerRightWebsiteLink.setTitle(nil, for: UIControlState.normal)
            distillerRightWebsiteLink.removeFromSuperview()
        }
            
        //  Neither link available
        else {
            distillerLeftWebsiteLink.setTitle(nil, for: UIControlState.normal)
            distillerLeftWebsiteLink.removeFromSuperview()
            distillerRightWebsiteLink.setTitle(nil, for: UIControlState.normal)
            distillerRightWebsiteLink.removeFromSuperview()
        }
        
        //------------------------OWNER------------------------
        if theDistillery.owner != nil && !theDistillery.owner.isEmpty {
            distillerOwnerOutlet.setTitle(theDistillery.owner, for: UIControlState.normal)
        } else {
            distillerOwnerOutlet.setTitle(nil, for: UIControlState.normal)
            distillerOwnerOutlet.removeFromSuperview()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
