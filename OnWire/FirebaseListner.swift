//
//  FirebaseListner.swift
//  OnWire
//
//  Created by Insinema on 28.11.2017.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit

@objc enum FirebaseListnerNotification: Int {
    case
    branch,
    settings,
    user
}

class FirebaseListner: NSObject {
    
    fileprivate static var _shared: FirebaseListner?
    static var shared: FirebaseListner{
        if _shared == nil{
            _shared = FirebaseListner()
        }
        return _shared!
    }
    
     private var _branchSet = Set<EMExperience>()
    
    fileprivate var outgoingNotifications = NSCountedSet()
    
    var user: EMUser?
    
    override init() {
        super.init()
        branchListner()
        settingsListner()
        userListner()
    }
    
    func reset(){
        FirebaseListner._shared = nil
    }
    
      //MARK: Listners
    
    func branchListner(){
        FirebaseManager.shared.branchAdded { (branch) in
            self._branchSet.insert(branch)
            self.postNotification(type: .branch)
        }
        
        FirebaseManager.shared.branchChanged { (branch) in
            self._branchSet.update(with: branch)
            self.postNotification(type: .branch)
        }
    }
    
    func settingsListner(){
    }
    
    func userListner(){
        FirebaseManager.shared.userAdded { (info) in
            self.user?.updateUser(info: info)
            self.postNotification(type: .user)
        }
        
        FirebaseManager.shared.userChanged { (info) in
            self.user?.updateUser(info: info)
            self.postNotification(type: .user)
        }
    }
    
    //branch
    func branchSet(includeDeleted:Bool)->Set<EMExperience>{
        if includeDeleted{
            return _branchSet
        }else{
            let filtered = _branchSet.filter({ (branch) -> Bool in
                return !branch.isDeleted.boolValue
            })
            return Set(filtered)
        }
    }
    
    func studentDict(includeDeleted:Bool)->[String:EMExperience]{
        let set = FirebaseListner.shared.branchSet(includeDeleted: includeDeleted)
        var branchDict = [String:EMExperience]()
        for branch in set{
            branchDict[branch.objectId] = branch
        }
        return branchDict
    }
    
    //MARK: FirebaseListnerNotifications
    
    func addListner(listner:NSObject, notificationType: FirebaseListnerNotification, selector: Selector){
        let notification = self.notification(type: notificationType)
        NotificationCenter.default.addObserver(listner, selector: selector, name: notification.name, object: nil)
    }
    
    func removeListner(listner:NSObject, notificationType: FirebaseListnerNotification){
        let notification = self.notification(type: notificationType)
        NotificationCenter.default.removeObserver(listner, name: notification.name, object: nil)
    }
    
    func postNotification(type:FirebaseListnerNotification){
        let waitingTime = 0.5
        outgoingNotifications.add(type.rawValue)
        if outgoingNotifications.count(for: type.rawValue) == 1{
            NotificationCenter.default.post(self.notification(type: type))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + waitingTime) {
                self.outgoingNotifications.remove(type.rawValue)
            }
        }else if outgoingNotifications.count(for: type.rawValue) == 2{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + waitingTime) {
                NotificationCenter.default.post(self.notification(type: type))
                self.outgoingNotifications.remove(type.rawValue)
            }
        }else{
            self.outgoingNotifications.remove(type.rawValue)
        }
    }
    
    private func notification(type:FirebaseListnerNotification)->Notification{
        return Notification(name: Notification.Name("FirebaseListnerNotification \(type.rawValue)"))
    }
}
