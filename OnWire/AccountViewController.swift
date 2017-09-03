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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logOut(_ sender: UIButton) {
        handleLogin()
    }
    
    func handleLogin() {
        
        do {
            try Auth.auth().signOut()
        } catch let loggoutError {
            print (loggoutError)
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(vc!, animated: true, completion: nil)
    }
}
