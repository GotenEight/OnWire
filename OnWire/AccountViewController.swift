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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func singOut() {
        try? Auth.auth().signOut()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        singOut()
    }
    
}
