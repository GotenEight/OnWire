//
//  SingUpViewController.swift
//  Chat
//
//  Created by Insinema on 23.08.17.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit
import Firebase

class SingUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Error")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { ( user, error) in if error != nil {
            return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://onwire-42c2d.firebaseio.com/")
            let userReference = ref.child("users").child(uid)
            let values = ["email": email,"password": password]
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    return
                }
            })
        })
    }
}
