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
    
    
    @IBOutlet weak var frameView: UIView!
    @IBOutlet weak var frameViewEqualHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var singUpButton: UIButton!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var keyboardInfo: NSDictionary?
    var keyboardIsShown = false
    let myKeychainWrapper = KeychainWrapper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTextField.attributedPlaceholder = NSAttributedString(string: "Nick name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        emailTextField.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SingUpViewController.frameViewTapped(_:)))
        frameView.addGestureRecognizer(tap)
        
        nickNameTextField.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        singUpButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(SingUpViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SingUpViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        frameViewEqualHightConstraint.constant = 0
        
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
        
        frameViewEqualHightConstraint.constant = keyboardHeight
        scrollViewBottomConstraint.constant += keyboardHeight
        let when = DispatchTime.now()+0.1
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIView.animate(withDuration: animationDuration, animations: {
                self.scrollView.layoutIfNeeded()
                var frame = self.singUpButton.frame
                frame.size.height += 20
                self.scrollView.scrollRectToVisible(frame, animated: true)
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
