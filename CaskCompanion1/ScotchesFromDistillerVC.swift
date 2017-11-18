//
//  ScotchesFromDistiller.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/8/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

class ScotchesFromDistillerVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    public var distillerName: String!
    public var distillerImage: UIImage!
    private var listScotches: [String]!
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var distillerNameOutlet: UILabel!
    @IBOutlet weak var distillerImageOutlet: UIImageView!
    @IBOutlet weak var scotchTableOutlet: UITableView!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if distillerName != nil {
            var name = distillerName!
            name += " Single Malts"
            distillerNameOutlet.text = name
        }

        if distillerImage != nil {
            distillerImageOutlet.image = distillerImage
        }
        else {
            distillerImageOutlet.image = #imageLiteral(resourceName: "DALLAS_DHU")
        }
        
        DBManager.shared.loadDistillersScotches(distillerName: distillerName!, listScotches: &listScotches)
        scotchTableOutlet.register(UITableViewCell.self, forCellReuseIdentifier: "scotchFromDistillerCell")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listScotches != nil {
            return listScotches.count
        }
        else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scotchFromDistillerCell", for: indexPath)
        let currentEntry = listScotches[indexPath.row]
        
        cell.textLabel?.text = currentEntry
        
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ScotchDetail") as! SingleScotchDetail
        nextVC.scotchKey = listScotches[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}
