//
//  ProgressButton.swift
//  OnWire
//
//  Created by Insinema on 21.12.2017.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit

class ProgressButton: UIButton {
  
    override func draw(_ rect: CGRect) {
        let numberOfProgress: CGFloat = 6
        let proccentNumber: CGFloat = numberOfProgress * 5
        self.setTitle("\(numberOfProgress)%", for: .normal)
        let width = (self.frame.size.width / 20)
        let doYourPath = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: width * numberOfProgress , height: self.frame.size.height))
        let layer = CAShapeLayer()
        layer.path = doYourPath.cgPath
        layer.fillColor = UIColor.green.cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.layer.addSublayer(layer)
        
    }
}
