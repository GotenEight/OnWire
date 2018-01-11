//
//  EMUser.swift
//  OnWire
//
//  Created by Insinema on 29.11.2017.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit

class EMUser: NSObject {
    
    var userId: String!
    var email: String!
    var platform: String?
    var subscriptionPlatform: String?
    var regionCode: String?
    var signUpDate: String?
    var subscriptionExpiration: NSNumber?
    var nickName: String!
    
    required init(userId: String) {
        super.init()
        self.userId = userId
    }
    
    func updateUser(info : [String:Any]){
        if let email = info["email"] as? String{
            self.email = email
        }
        if let signUpDate = info["signUpDate"] as? String{
            self.signUpDate = signUpDate
        }
        if let regionCode = info["regionCode"] as? String{
            self.regionCode = regionCode
        }
        if let platform = info["platform"] as? String{
            self.platform = platform
        }
        if let subscriptionExpiration = info["subscriptionExpiration"] as? NSNumber{
            self.subscriptionExpiration = subscriptionExpiration
        }
        if let subscriptionPlatform = info["subscriptionPlatform"] as? String{
            self.subscriptionPlatform = subscriptionPlatform
        }
        if let nickName = info["nickName"] as? String {
            self.nickName = nickName
        }
    }
}
