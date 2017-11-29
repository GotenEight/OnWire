//
//  EMObject.swift
//  OnWire
//
//  Created by Insinema on 29.11.2017.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit

class EMObject: NSObject {
    var objectId = ""
    
    override var hash : Int {
        return objectId.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? EMObject {
            return self.hash == other.hash
        } else {
            return false
        }
    }
}
