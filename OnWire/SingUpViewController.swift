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
    
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var singUpButton: UIButton!
    
    let myKeychainWrapper = KeychainWrapper()
    
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
    
    func getTimestamp(date: Date)->NSNumber?{
        let dateFormatter : DateFormatter = {
            let dateF = DateFormatter()
            dateF.dateFormat = "MMM dd yyyy"
            return dateF
        }()
        let str = dateFormatter.string(from: date)
        var timestamp : NSNumber?
        if let strippedDate = dateFormatter.date(from: str){
            timestamp = NSNumber(value: strippedDate.timeIntervalSince1970 as Double)
        }
        return timestamp
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        
        guard let nickName = nickNameTextField.text, let email = emailTextField.text, let password = passwordTextField.text else {return}

            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
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
            if let nickName = self.nickNameTextField.text {
                dict["nickName"] = nickName
            }
            FirebaseManager.shared.updateUserWithInfo(data: dict)
            
            let defaults = UserDefaults.standard
            defaults.setValue(email, forKey: LoginViewController.loginKey)
            defaults.synchronize()
            self.myKeychainWrapper.mySetObject(password, forKey:kSecValueData)
            self.myKeychainWrapper.writeToKeychain()
            FirebaseManager.shared.showScreen(type: .initial)
        })
    }
    
    func showError(_ message:String){
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            alertController.dismiss(animated: true, completion:nil)
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        return
    }
}
