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
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var singUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: "Nick name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        nickNameTextField.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        singUpButton.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let nickName = nickNameTextField.text else {
            return
        }
        if email == "" {
            emailTextField.layer.borderWidth = 2
            emailTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            emailTextField.layer.borderWidth = 0
        }
        if nickName == "" {
            nickNameTextField.layer.borderWidth = 2
            nickNameTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            nickNameTextField.layer.borderWidth = 0
        }
        if password == "" {
            passwordTextField.layer.borderWidth = 2
            passwordTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            passwordTextField.layer.borderWidth = 0
        }
        if passwordTextField.layer.borderWidth + emailTextField.layer.borderWidth + nickNameTextField.layer.borderWidth == 0 {
        
            Auth.auth().createUser(withEmail: email, password: password, completion: { ( user, error) in if error != nil {
            return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://onwire-42c2d.firebaseio.com/")
            let userReference = ref.child("users").child(uid)
                let values = ["email": email,"password": password,"nickName": nickName,]
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    return
                }
            })
        })
        } else {
            return
        }
    }
}
