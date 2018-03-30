//
//  MyScotchRatingsVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/4/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

struct userScotchScoring {
    var rating: Int!
    var date: Date!
    var transID: Int!
}

class MyScotchRatingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    public var scotchName: String!
    public var scotchAgeAbv: String!
    public var scotchImg: UIImage!  //Holding here to pass to rating form if appropriate
    private var scoringEntries: [userScotchScoring]!
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var scotchNameOutlet: UILabel!
    @IBOutlet weak var ageAbvOutlet: UILabel!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    @IBAction func rateItAgainButton(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RateAScotch") as! RateScotchVC
        if scotchName != nil {
            nextVC.scotchName = scotchName
        }
        if scotchAgeAbv != nil {
            nextVC.scotchAgeAbv = scotchAgeAbv
        }
        if scotchImg != nil {
            nextVC.scotchImage = scotchImg
        }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //DBManager.shared.loadUserScoring(scotchName: scotchName, scoringArray: &scoringEntries)
        
        if scotchName != nil {
            scotchNameOutlet.text = scotchName
        }
        if scotchAgeAbv != nil {
            ageAbvOutlet.text = scotchAgeAbv
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //To force-reload from the database
        scoringEntries = nil
        DBManager.shared.loadUserScoring(scotchName: scotchName, scoringArray: &scoringEntries)
        tableViewOutlet.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if scoringEntries != nil {
            return scoringEntries.count
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if scoringEntries == nil {
            return MyScotchRatingCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell", for: indexPath) as! MyScotchRatingCell
        let currentEntry = scoringEntries[indexPath.row]
        
        cell.userRatingOutlet.text = String(currentEntry.rating)
        cell.dateScoredOutlet.text = DateHandler.shared.convertDateToString(dateVal: currentEntry.date)
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            //  Remove the tuple from the database
            if DBManager.shared.deleteUserRating(transactionToDel: scoringEntries[indexPath.row].transID!) {
                //  Remove from array scoringEntries
                scoringEntries.remove(at: indexPath.row)
                
                //  Remove from tableView
                tableView.reloadData()
            }
        }
    }

}
