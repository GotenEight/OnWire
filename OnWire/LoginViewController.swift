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
    
    static let loginKey = "login"
    let myKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextField.attributedPlaceholder = NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        loginTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        singUpButton.layer.cornerRadius = 10
        singInButton.layer.cornerRadius = 10
        
        if let login = UserDefaults.standard.string(forKey: LoginViewController.loginKey){
            loginTextField.text = login
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        guard let email = loginTextField.text, let password = passwordTextField.text else {return}
        login(email: email, password: password)
    }
    
    func login(email:String,password:String){

        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error{
                self.showAlert(title:"Oops!", message: error.localizedDescription)
                return
            }
            UserDefaults.standard.setValue(email, forKey: LoginViewController.loginKey)
            UserDefaults.standard.synchronize()
            self.myKeychainWrapper.mySetObject(password, forKey:kSecValueData)
            self.myKeychainWrapper.writeToKeychain()
            
            FirebaseManager.shared.showScreen(type: .initial)
        })
    }
    
    func showAlert(title:String, message:String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                alertController.dismiss(animated: true, completion:nil)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
