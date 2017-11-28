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
    
    fileprivate var outgoingNotifications = NSCountedSet()
    
    var user: EMUser?
    
    override init() {
        super.init()
        settingsListner()
        userListner()
    }
    
    func reset(){
        FirebaseListner._shared = nil
    }
    
      //MARK: Listners
    
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
