//
//  LoginViewController.swift
//  Chat
//
//  Created by Insinema on 23.08.17.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var singInButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        singUpButton.layer.cornerRadius = 10
        singInButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        guard let email = loginTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
            return
                }
            self.dismiss(animated: true, completion: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController")
            self.present(vc!, animated: true, completion: nil)
        })
    }
}
