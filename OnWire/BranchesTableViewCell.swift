//
//  BranchesTableViewCell.swift
//  OnWire
//
//  Created by Insinema on 04.12.2017.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit

class BranchesTableViewCell: UITableViewCell {
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var branchLvl: UILabel!
    @IBOutlet weak var branchProccentage: UILabel!
    @IBOutlet weak var progressView: ProgressView!
    var experiencePoints: Int!
    var branchLvlString: String!
    var branchId: String!
    var lvlInt: Int!
    var branchArray: EMExperience?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
