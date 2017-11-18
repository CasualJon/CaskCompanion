//
//  DistillerMappingVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/7/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit
import MapKit

class DistillerMappingVC: UIViewController {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Fields
    /////////////////////////////////////////////////////////////////////////////////////
    var lat: Double!
    var long: Double!
    var distiller: String!
    var scotchRegion: String!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var mapOutlet: MKMapView!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(5.5, 2.5)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, long!)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapOutlet.setRegion(region, animated: true)
        
        let marker = MKPointAnnotation()
        marker.coordinate = location
        marker.title = distiller!
        marker.subtitle = scotchRegion!
        mapOutlet.addAnnotation(marker)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
