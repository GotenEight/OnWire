//
//  ProgressView.swift
//  OnWire
//
//  Created by Insinema on 03.01.2018.
//  Copyright © 2018 EvM. All rights reserved.
//

import UIKit
import Firebase

 @IBDesignable class ProgressView: UIView {
    static let shared = ProgressView()
    var points = 0
    
    
    override func draw(_ rect: CGRect) {
        let width = ((self.bounds.width / 20) * CGFloat(points))
        let green = UIColor.green
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: self.bounds.height))
        green.setFill()
        path.fill()
    }
}
