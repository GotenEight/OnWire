//
//  MessengerTableViewCell.swift
//  OnWire
//
//  Created by Insinema on 20.09.17.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit
import Firebase

class MessengerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkIfUserIsLoogedIn()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func checkIfUserIsLoogedIn() {
        let user = Auth.auth().currentUser
        let uid = user?.uid
        let name =  Database.database().reference().child("users").child(uid!).observe(.value, with: { (name) in
            if let dictionary = name.value as? [String: AnyObject] {
                print(dictionary["nickName"])
                let n = MessengerTableViewCell()
                self.nickNameLabel.text = dictionary["nickName"] as! String
            }
        })
    }
}
