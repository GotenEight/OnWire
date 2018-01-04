//
//  LevelView.swift
//  OnWire
//
//  Created by Insinema on 28.10.17.
//  Copyright © 2017 EvM. All rights reserved.
//

import UIKit
import Firebase

@IBDesignable  class LevelView: UIView {
    
    static let shared = LevelView()
    
    private struct Constants {
        static let numberOfPoints = 20
        static let lineWidth: CGFloat = 0
        static let arcWidth: CGFloat = 57
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    var counter: Int!
    var pathArray = [UIBezierPath]()
    var counterColorArray = [UIColor]()
    var r: CGFloat = 230.0
    var g: CGFloat = 243.0
    var b: CGFloat = 252.0
    var value = 0
    
    @IBInspectable var outlineColor: UIColor = UIColor.white
    @IBInspectable var pointCounterColor = UIColor.init(red: 52.0/255.0, green: 129.0/255.0, blue: 195.0/255.0, alpha: 1)
    var counterColor: UIColor?
    
    override func draw(_ rect: CGRect) {
        //crate	circle with start color
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius: CGFloat = max(bounds.width, bounds.height)
        let startAngle: CGFloat = (.pi / 2) * 1.0000001
        let endAngle: CGFloat = .pi / 2
        
        for i in 0...Constants.numberOfPoints {
            let angleDifference: CGFloat = .pi*2 - startAngle + endAngle
            let arcLengthPerPoint = angleDifference / CGFloat(Constants.numberOfPoints)
            let angle = (.pi*3 / 2) * 1.0000001 + arcLengthPerPoint*CGFloat(i)
            let pointEndAngle: CGFloat = angle + arcLengthPerPoint
            let path = UIBezierPath(arcCenter: center,
                                         radius: radius/2 - Constants.arcWidth/2,
                                         startAngle: angle,
                                         endAngle: pointEndAngle,clockwise: true)
            value = value + 1
            if value > 0 && value < 11 {
                r -= 18.0
                g -= 7.0
                b -= 2.5
            }
            if value > 11 && value < 21 {
                r += 18.0
                g += 7.0
                b += 2.5
            }
         
            let counterColor = UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
            self.counterColor = counterColor
            pathArray.append(path)
            pathArray[i].lineWidth = Constants.arcWidth
            counterColorArray.append(counterColor)
            counterColorArray[i].setStroke()
            pathArray[i].stroke()
        }

        
        // Create circle with points color
        if counter > 0 {
            for i in 1...counter {
                let angleDifference: CGFloat = .pi*2 - startAngle + endAngle
                let arcLengthPerPoint = angleDifference / CGFloat(Constants.numberOfPoints)
                let pointStartAngle = (.pi*3 / 2) * 1.0000001 + arcLengthPerPoint*CGFloat(i-1)
                let pointEndAngle: CGFloat = pointStartAngle + arcLengthPerPoint
            
            
                let pointPath = UIBezierPath(arcCenter: center,
                                         radius: radius/2 - Constants.arcWidth/2,
                                         startAngle: pointStartAngle,
                                         endAngle: pointEndAngle,
                                         clockwise: true)
                pointPath.lineWidth = Constants.arcWidth
                pointCounterColor.setStroke()
                pointPath.stroke()
            }
        }
        // Crate border
        let angleDifference: CGFloat = .pi*2 - startAngle + endAngle
        let arcLengthPerPoint = angleDifference / CGFloat(Constants.numberOfPoints)
        let outlineEndAngle = endAngle
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: bounds.width/2 - Constants.halfOfLineWidth,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        outlinePath.addArc(withCenter: center,
                           radius: bounds.width/2 - Constants.arcWidth + Constants.halfOfLineWidth,
                           startAngle: outlineEndAngle,
                           endAngle: startAngle,
                           clockwise: false)
        outlinePath.close()
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
 
   // create markers
        
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()
        outlineColor.setFill()
        
        let markerWidth: CGFloat = 1.0
        let markerSize: CGFloat = 57.0
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerSize))
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
       
        for i in 1...Constants.numberOfPoints {
            context.saveGState()
            let angle = arcLengthPerPoint * CGFloat(i) + startAngle - .pi / 2
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2 - markerSize)
            markerPath.fill()
            context.restoreGState()
        }
        context.restoreGState()
    }
}

