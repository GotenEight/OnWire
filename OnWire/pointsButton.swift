//
//  pointsButton.swift
//  OnWire
//
//  Created by Insinema on 04.11.17.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit

@IBDesignable class pointsButton: UIButton {
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }

    override  func  draw ( _ rect: CGRect) {
        let path = UIBezierPath (ovalIn: rect)
        UIColor.init(red: 150.0/255.0, green: 190.0/255.0, blue: 227.0/255.0, alpha: 1.0).setFill()
        path.fill ()
        
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
            x: halfWidth - halfPlusWidth,
            y: halfHeight))
        
        //add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
            x: halfWidth + halfPlusWidth,
            y: halfHeight))
        
        //set the stroke color
        UIColor.white.setStroke()
        
        
        plusPath.move(to: CGPoint(
            x: halfWidth + Constants.halfPointShift,
            y: halfHeight - halfPlusWidth + Constants.halfPointShift))
        
        plusPath.addLine(to: CGPoint(
            x: halfWidth + Constants.halfPointShift,
            y: halfHeight + halfPlusWidth + Constants.halfPointShift))
        
         plusPath.stroke()
    }

}
