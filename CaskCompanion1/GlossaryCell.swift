//
//  GlossaryCell.swift
//  CaskCompanion1
//
//  Created by Jonathan Cyrus on 7/25/17.
//  Copyright © 2018 Jon Cyrus. All rights reserved.
//

import UIKit

class GlossaryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var glossaryTerm: UILabel!
    
    @IBOutlet weak var glossaryDefinition: UILabel!
}
