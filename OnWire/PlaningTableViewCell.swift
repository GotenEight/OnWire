//
//  PlaningTableViewCell.swift
//  OnWire
//
//  Created by Insinema on 31.01.2018.
//  Copyright © 2018 EvM. All rights reserved.
//

import UIKit

class PlaningTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var planLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
