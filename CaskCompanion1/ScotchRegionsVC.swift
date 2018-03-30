//
//  ScotchRegionsVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 7/29/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

class ScotchRegionsVC: UIViewController {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    private var imgArray = [UIImage]()
    private var scotchRegions: [String]?
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var primaryScroll: UIScrollView!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Open connection to database and pull an ordered list of regions...
        //  Frankly, given the below implementation, this is now likely redundant, but is 
        //  still used at this time for troubleshooting order of images, etc.
        if let regions = DBManager.shared.getOrderedListSingleTable(field: "region", table: "Location", orderBy: "region") {

            //  Commented out debug code used to print regions to console
            /*
            for val in regions {
                print(val)
            }
            */
            
            //  Set scotchRegions array with contents pulled from database
            scotchRegions = regions
        }
        
        //  Array of image literals illustrating the various Scotch regions across 
        //  Scotland (loaded here in alphabetic order by region name)
        imgArray = [#imageLiteral(resourceName: "Regions_Campbeltown_W1600_H1950"), #imageLiteral(resourceName: "Regions_Highlands_W1600_H1950"), #imageLiteral(resourceName: "Regions_Islands_W1600_H1950"), #imageLiteral(resourceName: "Regions_Islay_W1600_H1950"), #imageLiteral(resourceName: "Regions_Lowlands_W1600_H1950"), #imageLiteral(resourceName: "Regions_Speyside_W1600_H1950")]
        
        //  For loop cycling through imgArray to show the correct picture per region
        for i in 0..<imgArray.count {
            
            //  Setup an image view and load the i-th element image
            let imgView = UIImageView()
            imgView.image = imgArray[i]
            
            //  Configure the frame info for the scroll view (primaryScroll) and the image view
            let xPos = self.view.frame.width * CGFloat(i)
            imgView.frame = CGRect(x: xPos, y: 0, width: self.view.frame.width, height: self.primaryScroll.frame.height)
            imgView.alpha = 0.75
            imgView.contentMode = .scaleAspectFit

            primaryScroll.contentSize.width = primaryScroll.frame.width * CGFloat(1 + i)
            primaryScroll.addSubview(imgView)
            
            //  Setup a text view and load the i-th element from the database pull of regions
            let txtView = UITextView()
            let displayTxt = DBManager.shared.getSingleFieldSingleTable(field: "definition", table: "TermsAndDefs", compareWhat: "term", compareHow: "=", compareAgainst: scotchRegions![i])
            if displayTxt != nil {
                txtView.text = displayTxt!
            }
            else {
                txtView.text = scotchRegions![i]
            }
            
            //  Configure the frame info for the text view
            txtView.frame = CGRect(x: xPos, y: 20, width: self.view.frame.width, height: self.primaryScroll.frame.height)
            txtView.backgroundColor = .clear
            txtView.textColor = .brown
            txtView.font = UIFont.boldSystemFont(ofSize: 14.0)
            txtView.isEditable = false
            primaryScroll.addSubview(txtView)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
