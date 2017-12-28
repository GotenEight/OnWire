//
//  EMExperience.swift
//  OnWire
//
//  Created by Insinema on 29.11.2017.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit

enum EMExperienceConst: String {
    case id = "id"
    case branchName = "branchName"
    case level = "level"
    case experiencePoints = "experiencePoints"
    case isDeleted = "isDeleted"
}

final class EMExperience: EMObject {
    var branchName: String!
    var level: Int!
    var experiencePoints: Int!
    var isDeleted: NSNumber!
    
    init?(info : [String:Any]) {
        super.init()
        guard let id = info[EMExperienceConst.id.rawValue] as? String else {return nil}
        guard let branchName = info[EMExperienceConst.branchName.rawValue] as? String else {return nil}
        guard let level = info[EMExperienceConst.level.rawValue] as? Int else {return nil}
        guard let experiencePoints = info[EMExperienceConst.experiencePoints.rawValue] as? Int else {return nil}
        guard let isDeleted = info[EMExperienceConst.isDeleted.rawValue] as? Bool else {return nil}
        
        self.objectId = id
        self.branchName = branchName
        self.level = level
        self.experiencePoints = experiencePoints
        self.isDeleted = isDeleted as NSNumber!
        
    }
    
    init(_ model: EMExperience) {
        super.init()
        objectId = model.objectId
        branchName = model.branchName
        level = model.level
        experiencePoints = model.experiencePoints
        isDeleted = model.isDeleted
    }
    
}

extension EMExperience: NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        return type(of: self).init(self)
    }
}
