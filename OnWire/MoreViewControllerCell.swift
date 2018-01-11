//
//  MoreViewControllerCell.swift
//  OnWire
//
//  Created by Insinema on 07.01.2018.
//  Copyright © 2018 EvM. All rights reserved.
//

import UIKit

class MoreViewControllerCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
