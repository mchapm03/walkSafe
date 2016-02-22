//
//  PieGraphView.swift
//  crossSafe
//
//  Created by Courtney Won on 2/20/16.
//  Adapted from Ray Wenderlich - Core Graphics Tutorial
//  Copyright © 2016 Tufts. All rights reserved.
//

import UIKit

let π:CGFloat = CGFloat(M_PI)

@IBDesignable class PieGraphView: UIView {
    //bad crosses color
    @IBInspectable var arcColor: UIColor = UIColor(red: 0.933333, green: 0.505882, blue: 0.474509, alpha: 1)
    //good crosses color
    @IBInspectable var circleColor: UIColor = UIColor(red: 0.505882, green: 0.909803, blue: 0.560784, alpha: 1)
    
// -------------------------------------------------
    //number of good/bad crosses
    var goodCross:Int = 5
    var badCross:Int = 3
// -------------------------------------------------
    
    override func drawRect(rect: CGRect) {
        
        //full circle (RED)
        // define center point
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        // define radius
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        // define width
        let arcWidth: CGFloat = 76
        
        // draw circle
        let path = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: 0,
            endAngle: 2*π,
            clockwise: true)
        
        path.lineWidth = arcWidth
        circleColor.setStroke()
        path.stroke()
        
        //overlay arc (GREEN)
        
        var totalCrossing:Int = goodCross + badCross
        
        let arcStartAngle: CGFloat =  0
        var arcEndAngle: CGFloat = ( (2 * π) / CGFloat(totalCrossing) ) * CGFloat(goodCross)
        
        // draw overlay arc
        let arcPath = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: arcStartAngle,
            endAngle: arcEndAngle,
            clockwise: true)
        
        arcPath.lineWidth = arcWidth
        arcColor.setStroke()
        arcPath.stroke()
        
    }
}
