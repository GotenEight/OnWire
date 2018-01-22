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
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var frameViewEqualHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var singInButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    static let loginKey = "login"
    let myKeychainWrapper = KeychainWrapper()
    
    var keyboardInfo: NSDictionary?
    var keyboardIsShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextField.attributedPlaceholder = NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        loginTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        singUpButton.layer.cornerRadius = 10
        singInButton.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.frameViewTapped(_:)))
        frameView.addGestureRecognizer(tap)
        
        if let login = UserDefaults.standard.string(forKey: LoginViewController.loginKey){
            loginTextField.text = login
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Keyboard
    @objc func keyboardWillHide(_ notification:Notification){
        keyboardInfo = (notification as NSNotification).userInfo as NSDictionary?
        hideKeyboard()
    }
    
    func hideKeyboard(){
        if !keyboardIsShown{
            return
        }
        var animationDuration = 0.4
        if let ad = (keyboardInfo?.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as AnyObject).doubleValue{
            animationDuration = ad
        }
        
        scrollViewBottomConstraint.constant = 0
        frameViewEqualHeightConstraint.constant = 0
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.scrollView.layoutIfNeeded()
        })
        keyboardIsShown = false
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        if keyboardIsShown{
            return
        }
        
        keyboardInfo = (notification as NSNotification).userInfo as NSDictionary?
        let userInfo:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        var animationDuration = 0.4
        if let ad = (keyboardInfo?.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as AnyObject).doubleValue{
            animationDuration = ad
        }
        
        frameViewEqualHeightConstraint.constant = keyboardHeight
        scrollViewBottomConstraint.constant += keyboardHeight
        let when = DispatchTime.now()+0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIView.animate(withDuration: animationDuration, animations: {
                self.scrollView.layoutIfNeeded()
                self.scrollView.scrollRectToVisible(self.singInButton.frame, animated: true)
            })
        }
        
        keyboardIsShown = true
    }
    
    @objc func frameViewTapped(_ sender:UITapGestureRecognizer){
        dismissKeyboard()
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
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
