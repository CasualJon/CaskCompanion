//
//  SelectScotchFromVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/1/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

/////////////////////////////////////////////////////////////////////////////////////
//  Structs for Scotch/Distiller/Owner SQLite3 DB
/////////////////////////////////////////////////////////////////////////////////////
struct scotchTuple {
    var scotchName: String!
    var scotchImg: String!
    var distiller: String!
    var abv: Float!
}

struct distilleryTuple {
    var distillerName: String!
    var distillerImg: String!
    var owner: String!
}

struct ownerTuple {
    var ownerName: String!
    var ownerImg: String!
}


class SelectScotchFromVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    //  searchFor to be set by calling View Controller when SelectScotchFrom VC is pushed onto the Navigation stack
    public var searchFor: String!
    private var normalColor: UIColor!
    
    //  searchTable to help define which relational table to return based on searchFor input
    private enum searchTable {
        case scotch
        case distiller
        case owner
    }
    
    //  searchWhat to hold detail about which current mode is in place
    private var searchWhat = searchTable.scotch
    
    //  Arrays to hold tuples returned from db queries for scotch, distiller, and owner
    private var scotchEntries: [scotchTuple]!
    private var distillerEntries: [distilleryTuple]!
    private var ownerEntries: [ownerTuple]!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var scotchOutlet: UIButton!
    @IBOutlet weak var scotchCountOutlet: UILabel!
    @IBOutlet weak var distillerOutlet: UIButton!
    @IBOutlet weak var distillerCountOutlet: UILabel!
    @IBOutlet weak var ownerOutlet: UIButton!
    @IBOutlet weak var ownerCountOutlet: UILabel!
    
    @IBAction func Scotch(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        searchWhat = searchTable.scotch
        resultsTable.reloadData()
        scotchOutlet.setTitleColor(.orange, for: UIControlState.normal)
        distillerOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        ownerOutlet.setTitleColor(normalColor, for: UIControlState.normal)
    }
    
    @IBAction func Distiller(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        searchWhat = searchTable.distiller
        scotchOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        distillerOutlet.setTitleColor(.orange, for: UIControlState.normal)
        ownerOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        resultsTable.reloadData()
    }
    
    @IBAction func Owner(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        searchWhat = searchTable.owner
        scotchOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        distillerOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        ownerOutlet.setTitleColor(.orange, for: UIControlState.normal)
        resultsTable.reloadData()
    }
    
    @IBOutlet weak var resultsTable: UITableView!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        if searchFor == nil {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        buildArrays(searchFor!)
        if scotchEntries != nil {
            var cntTxt = "("
            cntTxt += String(scotchEntries.count)
            cntTxt += ")"
            scotchCountOutlet.text = cntTxt
        } else {
            scotchCountOutlet.text = "(0)"
        }
        
        if distillerEntries != nil {
            var cntTxt = "("
            cntTxt += String(distillerEntries.count)
            cntTxt += ")"
            distillerCountOutlet.text = cntTxt
        } else {
            distillerCountOutlet.text = "(0)"
        }
        
        if ownerEntries != nil {
            var cntTxt = "("
            cntTxt += String(ownerEntries.count)
            cntTxt += ")"
            ownerCountOutlet.text = cntTxt
        } else {
            ownerCountOutlet.text = "(0)"
        }
        
        //  searchWhat starts as .scotch, so storing the default color and set new color as selected
        normalColor=scotchOutlet.titleColor(for: UIControlState.normal)
        scotchOutlet.setTitleColor(.orange, for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    //  NAME:   tableView() - NUMBER OF ROWS IN SECTION
    //  PARAMS: tableView: UITableView, numberOfRowsInSection: Int
    //  RETURN: Int
    //  BUGS:   None
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  Method constant to return if user requested data type has a nil Array optional
        let none = 0
        
        //  Switch to find what data type user is looking to see (scotch, owner, distiller)
        //  and set returned value to the count of that array; if nil, return 0
        switch searchWhat {
        
        case searchTable.distiller:
            if distillerEntries != nil {
                return distillerEntries.count
            }
            else {
                return none
            }
        
        case searchTable.owner:
            if ownerEntries != nil {
                return ownerEntries.count
            }
            else {
                return none
            }
        
        case searchTable.scotch:
            if scotchEntries != nil {
                return scotchEntries.count
            }
            else {
                return none
            }
        }
    }
    
    
    //  NAME:   tableView() - CELL FOR ROW AT
    //  PARAMS: tableView: UITableView, cellForRowAt: Index Path
    //  RETURN: UITableViewCell
    //  BUGS:   None
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch searchWhat {
        
        //  DISTILLER case to build and return distillery cell
        case searchTable.distiller:
            if distillerEntries == nil {
                return DistilleryCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "distilleryCell", for: indexPath) as! DistilleryCell
            let currentEntry = distillerEntries[indexPath.row]
            
            cell.distilleryName.text = currentEntry.distillerName
//  FIXME - this was removed for the time being because the inclusion of one (without another above) caused the height of the row to shrink
//            cell.distilleryOwner.text = currentEntry.owner
            cell.backgroundColor = .clear
            
            return cell
        
        //  OWNER case to build and return owner cell
        case searchTable.owner:
            if ownerEntries == nil {
                return OwnerCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ownerCell", for: indexPath) as! OwnerCell
            let currentEntry = ownerEntries[indexPath.row]
            
            cell.ownerName.text = currentEntry.ownerName
            cell.backgroundColor = .clear
            
            return cell
        
        //  SCOTCH case will build and return scotch cell
        case searchTable.scotch:
            if scotchEntries == nil {
                return ScotchCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "scotchCell", for: indexPath) as! ScotchCell
            let currentEntry = scotchEntries[indexPath.row]
            
            cell.scotchName.text = currentEntry.scotchName
//  FIXME - this was removed for the time being because the inclusion of one (without both) caused the height of the row to shrink
//            var abvText = String(currentEntry.abv)
//            abvText += " %"
//            cell.scotchABV.text = abvText
//            cell.scotchDistiller.text = currentEntry.distiller
            cell.backgroundColor = .clear
            
            return cell
        }
    }
    
    
    //  NAME:   tableView() - DID SELECT ROW AT
    //  PARAMS: tableView: UITableView, didSelectRowAt: Index Path
    //  RETURN: Void
    //  BUGS:   None
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchWhat {
            
        case searchTable.distiller:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "DistillerDetail") as! SingleDistillerDetail
            nextVC.distillerKey = distillerEntries[indexPath.row].distillerName
            self.navigationController?.pushViewController(nextVC, animated: true)
        
        case searchTable.owner:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "OwnerDetail") as! SingleOwnerDetail
            nextVC.ownerKey = ownerEntries[indexPath.row].ownerName
            self.navigationController?.pushViewController(nextVC, animated: true)
        
        case searchTable.scotch:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ScotchDetail") as! SingleScotchDetail
            nextVC.scotchKey = scotchEntries[indexPath.row].scotchName
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    //  NAME:   buildArrays()
    //  USAGE:  Takes the user-supplied search term and interacts with the DBManager to build the scotch, 
    //          distiller, and owner stuct arrays (passed as inout, or - essentially - by reference)
    //  PARAMS: searchTerm: String!
    //  RETURN: Void
    //  BUGS:   None
    func buildArrays(_ searchTerm: String!) {
        DBManager.shared.buildAdHocUserSearchArrays(srchPhrase: searchTerm, scotchArray: &scotchEntries, distillerArray: &distillerEntries, ownerArray: &ownerEntries)
    }
}
