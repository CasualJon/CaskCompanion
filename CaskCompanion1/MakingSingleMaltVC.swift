//
//  MakingSingleMaltVC.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 7/29/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

class MakingSingleMaltVC: UIViewController {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var textView: UITextView!

    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
