//
//  OwnerCell.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 8/3/17.
//  Copyright © 2017 Jon Cyrus. All rights reserved.
//

import UIKit

class OwnerCell: UITableViewCell {
    
    /////////////////////////////////////////////////////////////////////////////////////
    //  Class Outlets
    /////////////////////////////////////////////////////////////////////////////////////
    @IBOutlet weak var ownerName: UILabel!
    
    
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
