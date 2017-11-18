//
//  MyScotchRatingCell.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/4/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

class MyScotchRatingCell: UITableViewCell {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var userRatingOutlet: UILabel!
    
    @IBOutlet weak var dateScoredOutlet: UILabel!
    
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Methods
    /////////////////////////////////////////////////////////////////////////////////////
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
