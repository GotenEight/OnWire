//
//  FirebaseManager.swift
//  OnWire
//
//  Created by Insinema on 28.11.2017.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit
import Firebase

enum screenType: Int {
    case login, signUp, initial
}

class FirebaseManager: NSObject {
    static let shared = FirebaseManager()
    
    override init() {
        super.init()
        authListner()
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            guard let connected = snapshot.value as? Bool else {
                return
            }
            print("Connection is \(connected)")
        })
    }
    
    var currentUser : User?
    
    var swapId: String?
    
    let ref = Database.database().reference()
    
    var userId: String?{
        if let swapId = self.swapId{
            return swapId
        }else if let userId = self.currentUser?.uid{
            return userId
        }else{
            return nil
        }
    }
    
    //MARK: Auth
    func authListner(){
        let _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user{
                self.currentUser = user
                FirebaseListner.shared.reset()
                FirebaseListner.shared.user = EMUser(userId: user.uid)
                if let window = UIApplication.shared.delegate?.window, let _ = window?.rootViewController as? SingUpViewController{
                    print("Skip auth actions")
                }else{
                    self.showScreen(type: .initial)
                }
            }else{
                let key = "FirstTime"
                if UserDefaults.standard.value(forKey: key) == nil{
                    self.showScreen(type: .signUp)
                    UserDefaults.standard.setValue(true, forKey: key)
                    UserDefaults.standard.synchronize()
                }else{
                    self.showScreen(type: .login)
                }
                
                FirebaseListner.shared.reset()
            }
        }
    }
    
    func showScreen(type: screenType){
        if type == .initial{
            presentInitialViewController()
            return
        }
        
        let identifier = type == .login ? "LogIn": "SignUp"
        let sbName = "Main"
        let storyboard = UIStoryboard(name: sbName, bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: identifier)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            appDelegate.window?.rootViewController = loginVC
        }
    }
    
    fileprivate func presentInitialViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? UITabBarController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let window = appDelegate?.window, let vc = vc {
                vc.selectedIndex = 2
                window.rootViewController = vc
        }
    }
    
    func signOut(){
        try? Auth.auth().signOut()
    }
    
    //MARK: User
    
    func userAdded(completion: @escaping (_ userInfo: [String:Any])->Void){
        guard let currentUserId = self.userId else {return}
        let ref = FirebaseManager.shared.ref.child("users/\(currentUserId)")
        ref.observe(.childAdded, with: { (snap) in
            if let value = snap.value{
                completion([snap.key:value])
            }
        })
    }
    
    func userChanged(completion: @escaping (_ userInfo: [String:Any])->Void){
        guard let currentUserId = self.userId else {return}
        let ref = FirebaseManager.shared.ref.child("users/\(currentUserId)")
        ref.observe(.childChanged, with: { (snap) in
            if let value = snap.value{
                completion([snap.key:value])
            }
        })
    }
    
    func updateUserWithInfo(data:[String:Any]){
        guard let currentUserId = self.userId else {return}
        let ref = FirebaseManager.shared.ref.child("users/\(currentUserId)")
        
        ref.updateChildValues(data)
    }
    
    //MARK: Students
    func planOnDayAdded(completion: @escaping (_ planOnDay: EMPlaning)->Void){
        guard let currentUserId = self.userId else {return}
        let _ref = ref.child("users/\(currentUserId)/planOnDay")
        
        _ref.observe(.childAdded, with: {(snap) in
            guard let info = snap.value as? [String:Any], let planOnDay = EMPlaning(info: info) else{
                return
            }
            completion(planOnDay)
        })
    }
    
    func planOnDayChanged(completion: @escaping (_ branch: EMPlaning)->Void){
        guard let currentUserId = self.userId else {return}
        let _ref = ref.child("users/\(currentUserId)/planOnDay")
        
        _ref.observe(.childChanged, with: {(snap) in
            guard let info = snap.value as? [String:Any], let planOnDay = EMPlaning(info: info) else{
                return
            }
            completion(planOnDay)
        })
    }
    
    func planOnDayCreate(_ info:[String:Any],completion:(_ objectId:String)->Void){
        guard let currentUserId = self.userId else {return}
        let _ref = ref.child("users/\(currentUserId)/planOnDay")
        let objectId = _ref.childByAutoId().key
        var updatedInfo = info
        updatedInfo["id"] = objectId
        _ref.updateChildValues([objectId:updatedInfo])
        completion(objectId)
    }
    
    
    // branches
    func branchAdded(completion: @escaping (_ branch: EMExperience)->Void){
        guard let currentUserId = self.userId else {return}
        let _ref = ref.child("users/\(currentUserId)/branches")
        
        _ref.observe(.childAdded, with: {(snap) in
            guard let info = snap.value as? [String:Any], let branch = EMExperience(info: info) else{
                return
            }
            completion(branch)
        })
    }
    
    func branchChanged(completion: @escaping (_ branch: EMExperience)->Void){
        guard let currentUserId = self.userId else {return}
        let _ref = ref.child("users/\(currentUserId)/branches")
        
        _ref.observe(.childChanged, with: {(snap) in
            guard let info = snap.value as? [String:Any], let branch = EMExperience(info: info) else{
                return
            }
            completion(branch)
        })
    }
    
    //Create student with given information
    func createBranch(_ info:[String:Any],completion:(_ objectId:String)->Void){
        guard let currentUserId = self.userId else {return}
        let _ref = ref.child("users/\(currentUserId)/branches")
        let objectId = _ref.childByAutoId().key
        var updatedInfo = info
        updatedInfo["id"] = objectId
        _ref.updateChildValues([objectId:updatedInfo])
        completion(objectId)
    }
    
    func deleteBranch(_ branchId: String) {
        guard let currentUserId = self.userId else {return}
        ref.child("users/\(currentUserId)/branches/\(branchId)").removeValue()
    }
    
    //Update excisting student with given information
    func updateBranch(_ branchId:String,info:[String:Any]){
        guard let currentUserId = self.userId else {return}
        let data = info
        ref.child("users/\(currentUserId)/branches/\(branchId)").updateChildValues(data)
    }

}
