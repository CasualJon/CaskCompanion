//
//  SearchByRegionVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/7/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

class SearchByRegionVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    private var normalColor: UIColor!
    
    //  searchTable to help define which relational table to return based on searchFor input
    private enum searchTable {
        case scotch
        case distiller
    }
    
    //  whatRegion to define which Region's data should be displaying
    private enum whatRegion {
        case campbeltown
        case highlands
        case islands
        case islay
        case lowlands
        case speyside
    }
    
    //  searchWhat to hold detail about which current mode is in place
    private var searchWhat = searchTable.distiller
    private var currRegion = whatRegion.highlands
    
    //  Arrays to hold tuples returned from db queries for scotch, distiller, and owner
    private var scotchEntries: [scotchTuple]!
    private var distillerEntries: [distilleryTuple]!
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var campbeltownOutlet: UIButton!
    @IBOutlet weak var highlandsOutlet: UIButton!
    @IBOutlet weak var islandsOutlet: UIButton!
    @IBOutlet weak var islayOutlet: UIButton!
    @IBOutlet weak var lowlandsOutlet: UIButton!
    @IBOutlet weak var speysideOutlet: UIButton!
    @IBOutlet weak var resultsTable: UITableView!
    
    @IBAction func campbeltownButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        updateOldButtonColorToNormal()
        currRegion = whatRegion.campbeltown
        campbeltownOutlet.setTitleColor(.orange, for: UIControlState.normal)
        distillerEntries = nil
        DBManager.shared.populateDistillerDetail(region: returnCurrentRegionString(), distillerEntries: &distillerEntries)
        resultsTable.reloadData()
    }
    
    @IBAction func highlandsButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        updateOldButtonColorToNormal()
        currRegion = whatRegion.highlands
        highlandsOutlet.setTitleColor(.orange, for: UIControlState.normal)
        distillerEntries = nil
        DBManager.shared.populateDistillerDetail(region: returnCurrentRegionString(), distillerEntries: &distillerEntries)
        resultsTable.reloadData()
    }
    
    @IBAction func islandsButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        updateOldButtonColorToNormal()
        currRegion = whatRegion.islands
        islandsOutlet.setTitleColor(.orange, for: UIControlState.normal)
        distillerEntries = nil
        DBManager.shared.populateDistillerDetail(region: returnCurrentRegionString(), distillerEntries: &distillerEntries)
        resultsTable.reloadData()
    }
    
    @IBAction func islayButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        updateOldButtonColorToNormal()
        currRegion = whatRegion.islay
        islayOutlet.setTitleColor(.orange, for: UIControlState.normal)
        distillerEntries = nil
        DBManager.shared.populateDistillerDetail(region: returnCurrentRegionString(), distillerEntries: &distillerEntries)
        resultsTable.reloadData()
    }
    
    @IBAction func lowlandsButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        updateOldButtonColorToNormal()
        currRegion = whatRegion.lowlands
        lowlandsOutlet.setTitleColor(.orange, for: UIControlState.normal)
        distillerEntries = nil
        DBManager.shared.populateDistillerDetail(region: returnCurrentRegionString(), distillerEntries: &distillerEntries)
        resultsTable.reloadData()
    }
    
    @IBAction func speysideButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        updateOldButtonColorToNormal()
        currRegion = whatRegion.speyside
        speysideOutlet.setTitleColor(.orange, for: UIControlState.normal)
        distillerEntries = nil
        DBManager.shared.populateDistillerDetail(region: returnCurrentRegionString(), distillerEntries: &distillerEntries)
        resultsTable.reloadData()
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //  Storing Original button color and setting the default selected color to Orange (Default = Highlands)
        normalColor = campbeltownOutlet.titleColor(for: UIControlState.normal)
        highlandsOutlet.setTitleColor(.orange, for: UIControlState.normal)
        
        DBManager.shared.populateDistillerDetail(region: returnCurrentRegionString(), distillerEntries: &distillerEntries)
        resultsTable.register(UITableViewCell.self, forCellReuseIdentifier: "distillerByRegion")
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultsTable.estimatedRowHeight = 44
        resultsTable.rowHeight = UITableViewAutomaticDimension
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resultsTable.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //  Required method implementation for UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if distillerEntries != nil {
            return distillerEntries.count
        }
        else {
            return 0
        }
    }
    
    
    //  Required method implementation for UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if distillerEntries == nil {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "distillerByRegion", for: indexPath)
        let currentEntry = distillerEntries[indexPath.row]
        
        cell.textLabel?.text = currentEntry.distillerName

        
        return cell

    }
    
    
    //  Optional helper method for UITableView
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    
    //  NAME:   tableView() - DID SELECT ROW AT
    //  PARAMS: tableView: UITableView, didSelectRowAt: Index Path
    //  RETURN: Void
    //  BUGS:   None
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DistillerDetail") as! SingleDistillerDetail
        nextVC.distillerKey = distillerEntries[indexPath.row].distillerName
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    
    //  NAME:   returnCurrentRegionString()
    //  USAGE:  Evaluates the currRegion variable and returns a string appropriate to the current region
    //  PARAMS: NA
    //  RETURN: String
    //  BUGS:   None
    func returnCurrentRegionString() -> String {
        switch currRegion {
        case whatRegion.campbeltown:
            return "Campbeltown"
        case whatRegion.highlands:
            return "Highlands"
        case whatRegion.islands:
            return "Islands"
        case whatRegion.islay:
            return "Islay"
        case whatRegion.lowlands:
            return "Lowlands"
        case whatRegion.speyside:
            return "Speyside"
        }
    }
    
    //  NAME:   updateOldButtonColorToNormal()
    //  USAGE:  Helper method to save time and sets.  Called after region button press, prior to 
    //          changing the currRegion var and setting the pressed button's new color to orange
    //  PARAMS: NA
    //  RETURN: Void
    //  BUGS:   None
    func updateOldButtonColorToNormal() {
        switch currRegion {
        case whatRegion.campbeltown:
            campbeltownOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        case whatRegion.highlands:
            highlandsOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        case whatRegion.islands:
            islandsOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        case whatRegion.islay:
            islayOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        case whatRegion.lowlands:
            lowlandsOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        case whatRegion.speyside:
            speysideOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        }
    }
}
