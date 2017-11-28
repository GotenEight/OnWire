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
    @IBOutlet weak var singUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        singUpButton.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        /*
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        if email == "" {
            emailTextField.layer.borderWidth = 2
            emailTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            emailTextField.layer.borderWidth = 0
        }
        
        if password == "" {
            passwordTextField.layer.borderWidth = 2
            passwordTextField.layer.borderColor = UIColor.red.cgColor
        } else {
            passwordTextField.layer.borderWidth = 0
        }
        if passwordTextField.layer.borderWidth + emailTextField.layer.borderWidth == 0 {
        
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
        } else {
            return
        }
    */
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        activityView.show(delay: nil)
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            self.activityView.hide()
            if let error = error{
                self.showError(error.localizedDescription)
                return
            }
            var dict = ["userId":FirebaseManager.shared.currentUser?.uid ?? "",
                        "email":email,
                        "platform":"iOS"]
            if let timestamp = self.getTimestamp(date:Date()){
                dict["signUpDate"] = "\(timestamp)"
            }
            if let regionCode = Locale.current.regionCode{
                dict["regionCode"] = regionCode
            }
            FirebaseManager.shared.updateUserWithInfo(data: dict)
            
            let defaults = UserDefaults.standard
            defaults.setValue(email, forKey: LoginViewController.loginKey)
            defaults.synchronize()
            self.myKeychainWrapper.mySetObject(password, forKey:kSecValueData)
            self.myKeychainWrapper.writeToKeychain()
            if DatabaseMigrateHelper.databaseExist(){
                let alert = UIAlertController(title: "Local Database Exists", message: "Do you want to migrate your local database?", preferredStyle: .alert)
                let migrateAction = UIAlertAction(title: "Migrate", style: .default, handler: { (action) in
                    self.migrateDatabase()
                })
                alert.addAction(migrateAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.preloadDatabase()
                })
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.preloadDatabase()
            }
        })
    }
}
