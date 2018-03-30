//
//  ScotchCell.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/3/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

class ScotchCell: UITableViewCell {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var scotchName: UILabel!
    
    @IBOutlet weak var scotchABV: UILabel!
    
    @IBOutlet weak var scotchDistiller: UILabel!

    
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
