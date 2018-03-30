//
//  AboutTheColorVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 7/31/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

/////////////////////////////////////////////////////////////////////////////////////
//  Struct for aboutColorTuple SQLite3 DB
/////////////////////////////////////////////////////////////////////////////////////
struct aboutColorTuple {
    var colorImg: String!
    var colorName: String!
}


class AboutTheColorVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    private var colorTypes: [aboutColorTuple]!
    private var normalColor: UIColor!
    private let meaningText = "The color of Scotch Whisky does not typically indicate quality, but can assist in narrowing personal preferences becasue of how color is imparted to the whisky. Specifically, the color is largely a clue to the type of cask used in aging the spirit, and the type of cask is one key to the flavor of a single malt. \n\nSpirit from the still is clear, and it is maturation that has the whisky adopt the color of the cask. Whisky aged in ex-bourbon casks often holds more yellow or golden hues where whisky aged in ex-sherry casks commonly absorbs a darker, more amber or auburn coloring. \n\nNo two casks will yeild precisely the same color, so many distillers will add coloring to resolve this natural variation. While there is a standing debate over the effect of coloring on taste, for the sake of marketing it ensures the whisky appears consistent when on the retail shelves."
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var meaningOutlet: UIButton!
    @IBOutlet weak var coloringOutlet: UIButton!
    
    
    @IBAction func coloring(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        setViewToTable()
        meaningOutlet.setTitleColor(normalColor, for: UIControlState.normal)
        coloringOutlet.setTitleColor(.orange, for: UIControlState.normal)
    }
    
    
    @IBAction func meaning(_ sender: UIButton) {
        if let buttonPressed = sender.currentTitle {
            WhiskyDo.shared.detailToConsole(option: buttonPressed)
        }
        
        setViewToText()
        meaningOutlet.setTitleColor(.orange, for: UIControlState.normal)
        coloringOutlet.setTitleColor(normalColor, for: UIControlState.normal)
    }
    
    
    @IBOutlet weak var viewHousing: UIView!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Storing Original button color and setting the default selected color to Orange
        normalColor = meaningOutlet.titleColor(for: UIControlState.normal)
        meaningOutlet.setTitleColor(.orange, for: UIControlState.normal)
        
        setViewToText()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //  NAME:   setViewToText()
    //  USAGE:  Updates the Superview viewHousing with a UITextView subview to detail information about the 
    //          meaning behind the different colors found in Scotch.
    //  PARAMS: None
    //  RETURN: Void
    //  BUGS:   None
    func setViewToText() {
        //  Clear out any existing subview before drawing new
        for view in viewHousing.subviews{
            view.removeFromSuperview()
        }
        
        //  Write out the details for the meaning of Scotch coloring
        let txtView = UITextView()
        txtView.text = meaningText
        
        txtView.font = UIFont(name: (txtView.font?.fontName)!, size: 14.0)
        txtView.frame = CGRect(x: 0, y: 0, width: self.viewHousing.frame.width, height: self.viewHousing.frame.height)
        txtView.backgroundColor = .clear
        
        txtView.isEditable = false
        
        viewHousing.addSubview(txtView)
    }
    
    
    //  NAME:   setViewToTable()
    //  USAGE:  Updates the Superview viewHousing with a UITableView subview to illustrate the 
    //          different colors (in general) found across different Scotches.
    //  PARAMS: None
    //  RETURN: Void
    //  BUGS:   None
    func setViewToTable() {
        //  Populate aboutColorTuple Struct array for table population
        colorTypes = DBManager.shared.getAbstractColorTuples()
        
        
        //  Clear out any existing subview before drawing new
        for view in viewHousing.subviews {
            view.removeFromSuperview()
        }
        
        //  Build and display the table of Scotch colors
        let tblView = UITableView()
        
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.frame = CGRect(x: 0, y: 0, width: self.viewHousing.frame.width, height: self.viewHousing.frame.height)
        tblView.backgroundColor = .clear
        
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "colorCell")
        
        viewHousing.addSubview(tblView)
    }
    
    
    //  Required helper method for UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  Get number of distinct "abstractGrouper" values held within the Color table of the database
        //  (these are the colors with image examples)
        return DBManager.shared.getAbstractColorCount()
    }
    
    
    //  Required helper method for UITableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorCell", for: indexPath)
        let currentEntry = colorTypes[indexPath.row]
        
        cell.textLabel?.text = currentEntry.colorName
        let colorExample = UIImage(named: currentEntry.colorImg)
        cell.imageView?.image = colorExample
        
        return cell
    }
    
    
    //  Optional helper method for UITableView
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}
