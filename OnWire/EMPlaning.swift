//
//  EMPlaning.swift
//  OnWire
//
//  Created by Insinema on 07.02.2018.
//  Copyright © 2018 EvM. All rights reserved.
//

import UIKit

enum EMPlaningConst: String {
    case id = "id"
    case firstTime = "firstTime"
    case secondTime = "secondTime"
    case planText = "planText"
    case isDeleted = "isDeleted"
}

final class EMPlaning: EMObject {
    var firstTime: Double!
    var secondTime: Double!
    var planText: String!
    var isDeleted: NSNumber!
    
    init?(info : [String:Any]) {
        super.init()
        guard let id = info[EMPlaningConst.id.rawValue] as? String else {return nil}
        guard let firstTime = info[EMPlaningConst.firstTime.rawValue] as? Double else {return nil}
        guard let secondTime = info[EMPlaningConst.secondTime.rawValue] as? Double else {return nil}
        guard let planText = info[EMPlaningConst.planText.rawValue] as? String else {return nil}
        guard let isDeleted = info[EMPlaningConst.isDeleted.rawValue] as? Bool else {return nil}
        
        self.objectId = id
        self.firstTime = firstTime
        self.secondTime = secondTime
        self.planText = planText
        self.isDeleted = isDeleted as NSNumber!
        
    }
    
    init(_ model: EMPlaning) {
        super.init()
        objectId = model.objectId
        firstTime = model.firstTime
        secondTime = model.secondTime
        planText = model.planText
        isDeleted = model.isDeleted
    }
    
}

extension EMPlaning: NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(self)
    }
}
