//
//  GlossaryVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 7/24/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

/////////////////////////////////////////////////////////////////////////////////////
//  Struct for Glossary SQLite3 DB
/////////////////////////////////////////////////////////////////////////////////////
struct glossaryTuple {
    var glossaryTerm: String!
    var glossaryDefinition: String!
}


class GlossaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    private var glossaryEntries: [glossaryTuple]!

    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var tblGlossary: UITableView!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblGlossary.allowsSelection = false
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        glossaryEntries = DBManager.shared.loadFullGlossary()
        tblGlossary.estimatedRowHeight = 44
        tblGlossary.rowHeight = UITableViewAutomaticDimension
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tblGlossary.reloadData()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (glossaryEntries != nil) ? glossaryEntries.count : 0
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if glossaryEntries == nil {
            return GlossaryCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "glossaryCell", for: indexPath) as! GlossaryCell
        let currentEntry = glossaryEntries[indexPath.row]
        
        cell.glossaryTerm.text = currentEntry.glossaryTerm
        cell.glossaryDefinition.text = currentEntry.glossaryDefinition
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    
}
