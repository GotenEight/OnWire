//
//  PersonAccount.swift
//  Chat
//
//  Created by Insinema on 24.08.17.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    @IBOutlet weak var levelLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LevelAndPoints()
    }
    
    func LevelAndPoints() {
        levelLabel.text = ("\(LevelView.shared.level)")
    }
}
