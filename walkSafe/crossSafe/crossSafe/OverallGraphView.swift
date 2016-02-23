//
//  OverallGraphView.swift
//  crossSafe
//
//  
import UIKit

@IBDesignable class OverallGraphView: UIView {
    
// -----------------------------------------------------------------
    //Weekly sample data
    var graphPoints:[Int] = [4, 6, 8, 9, 10, 10, 12]
    var graphPointsBad: [Int] = [8, 6, 4, 3, 2, 2, 0]
// -----------------------------------------------------------------
    
    //1 - the properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    override func drawRect(rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        //set up background clipping area
        let path = UIBezierPath(roundedRect: rect,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        //2 - get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        //3 - set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //4 - set up the color stops
        let colorLocations:[CGFloat] = [0.0, 1.0]
        
        //5 - create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace,
            colors,
            colorLocations)
        
        //6 - draw the gradient
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x:0, y:self.bounds.height)
        CGContextDrawLinearGradient(context,
            gradient,
            startPoint,
            endPoint,
            [])
        
        //calculate the x point
        
        let margin:CGFloat = 20.0
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin*2 - 4) /
                CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // calculate the y point
        
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.maxElement()!
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) /
                CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        // draw the line graph for Good Points
        
        UIColor(red: 0.54117647, green: 0.9764705, blue: 0.584313, alpha: 1).setFill()
        UIColor(red: 0.54117647, green: 0.9764705, blue: 0.584313, alpha: 1).setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        //go to start of line
        graphPath.moveToPoint(CGPoint(x:columnXPoint(0),
            y:columnYPoint(graphPoints[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                y:columnYPoint(graphPoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }
        
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect:
                CGRect(origin: point,
                    size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        // draw the line graph for Bad Points
        
        UIColor(red: 0.976470, green: 0.541176, blue: 0.541176, alpha: 1).setFill()
        UIColor(red: 0.976470, green: 0.541176, blue: 0.541176, alpha: 1).setStroke()
        
        //set up the points line
        let graphPathBad = UIBezierPath()
        //go to start of line
        graphPathBad.moveToPoint(CGPoint(x:columnXPoint(0),
            y:columnYPoint(graphPointsBad[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x, y) for the point
        for i in 1..<graphPointsBad.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                y:columnYPoint(graphPointsBad[i]))
            graphPathBad.addLineToPoint(nextPoint)
        }
        
        //draw the line on top of the clipped gradient
        graphPathBad.lineWidth = 2.0
        graphPathBad.stroke()
        
        //Draw the circles on top of graph stroke
        for i in 0..<graphPointsBad.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPointsBad[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect:
                CGRect(origin: point,
                    size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.moveToPoint(CGPoint(x:margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin,
            y:topBorder))
        
        //center line
        linePath.moveToPoint(CGPoint(x:margin,
            y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.moveToPoint(CGPoint(x:margin,
            y:height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x:width - margin,
            y:height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
    }
    
}
