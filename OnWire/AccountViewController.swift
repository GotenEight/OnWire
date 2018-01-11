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
    @IBOutlet weak var plus: UIButton!
    @IBOutlet weak var minus: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var levelView: LevelView!
    var experiencePoints: Int!
    var level: String!
    var branchId: String!
    var lvlInt: Int!
    var array: EMExperience?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.levelView.counter = experiencePoints
        self.levelLabel.text = String(lvlInt)
        self.levelView.level = lvlInt
        let image = UIImage(named: "FirstNameIcon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(branchTasks))
        title = array?.branchName
        
        plus.layer.borderWidth = 0.5
        plus.layer.cornerRadius = 10
        minus.layer.borderWidth = 0.5
        minus.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func singOut() {
        try? Auth.auth().signOut()
    }
    
    @objc func branchTasks() {
        performSegue(withIdentifier: "task", sender: nil)
    }
    
    func setFirebase() {
        if self.levelView.level != nil {
            var dict = ["branchName": array?.branchName,
                        "level": self.lvlInt,
                        "experiencePoints": self.levelView.counter,
                        "isDeleted": false ] as [String:Any]
        FirebaseManager.shared.updateBranch(branchId, info: dict)
        }
    }
    
    @IBAction func plusOne(_ sender: UIButton) {
        self.levelView.counter = self.levelView.counter + 1
        if self.levelView.counter > 19 {
            self.lvlInt! += 1
            self.levelLabel.text = String(lvlInt)
            self.levelView.counter = 0
        }
        setFirebase()
        levelView.setNeedsDisplay()
    }
    
    @IBAction func minusOne(_ sender: UIButton) {
        self.levelView.counter = self.levelView.counter - 1
        if self.levelView.counter == -1 {
            self.lvlInt! -= 1
            self.levelLabel.text = String(lvlInt)
            self.levelView.counter = 19
        }
        
        if lvlInt < 1 {
            self.levelView.counter = 0
            self.lvlInt = 1
            self.levelLabel.text = String(lvlInt)
        }
        setFirebase()
        levelView.setNeedsDisplay()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        singOut()
    }
    
}
