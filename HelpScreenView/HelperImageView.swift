//
// Created by Sergey Sokoltsov on 11/27/15.
// Copyright (c) 2015 Appus. All rights reserved.
//

import UIKit

extension Float {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}

extension Float {
    var radiansToDegrees : CGFloat {
        return CGFloat(self) * CGFloat(M_PI) / 180.0
    }
}
class HelperImageView: UIImageView {

    let DEFAULT_TIP_ANGLE = 15
    let DEFAULT_TIP_LENGTH = 25 as CGFloat
    let DEFAULT_PIN_POSITION = 0.4 as CGFloat
    let DEFAULT_LINE_WIDTH = 2.0 as CGFloat

    var lineWidth: CGFloat
    var color: UIColor

    override init(frame: CGRect) {
        lineWidth = DEFAULT_LINE_WIDTH
        color = UIColor.whiteColor()
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        lineWidth = DEFAULT_LINE_WIDTH
        color = UIColor.whiteColor()
        
        super.init(coder: aDecoder)
    }
    
    init() {
        lineWidth = DEFAULT_LINE_WIDTH
        color = UIColor.whiteColor()
        super.init(image:nil)
    }

    // draw arrow with start and end points
    // with tip on start(onStart) and on finish(onFinish)
    internal func drawArrow(start: CGPoint, end: CGPoint, onStart: Bool, onFinish: Bool, tipLength: CGFloat) {
        // Initialise
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)

        self.image!.drawInRect(self.bounds)

        //drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, self.lineWidth)
        CGContextSetStrokeColorWithColor(context, self.color.CGColor)

        CGContextMoveToPoint(context, start.x, start.y)
        CGContextAddLineToPoint(context, end.x, end.y)

        var angle = self.pointPairToBearingDegrees(end, secondPoint:start)

        if(onFinish){
            CGContextMoveToPoint(context, end.x, end.y)

            // add first part of arrow's tip
            var arPoint = self.getArrowSidePoint(end, length:tipLength, angle:angle)
            CGContextAddLineToPoint(context, arPoint.x, arPoint.y);

            //move back to end of line
            CGContextMoveToPoint(context, end.x, end.y)
            // draw second part of tip
            arPoint = self.getArrowSidePoint(end, length:tipLength, angle:angle - CGFloat((DEFAULT_TIP_ANGLE*2)))
            CGContextAddLineToPoint(context, arPoint.x, arPoint.y)
        }
        if(onStart)
        {
            angle = self.pointPairToBearingDegrees(start, secondPoint:end);

            CGContextMoveToPoint(context, start.x, start.y)
            // add first part of arrow's tip
            var arPoint = self.getArrowSidePoint(start, length:tipLength, angle:angle)
            CGContextAddLineToPoint(context, arPoint.x, arPoint.y)

            //move back to end of line
            CGContextMoveToPoint(context, start.x, start.y)
            // draw second part of tip
            arPoint = self.getArrowSidePoint(start, length:tipLength, angle:angle - CGFloat((DEFAULT_TIP_ANGLE*2)))
            CGContextAddLineToPoint(context, arPoint.x, arPoint.y)
        }

        CGContextStrokePath(context);

        // Grab it as an autoreleased image

        let newImage = UIGraphicsGetImageFromCurrentImageContext();

        self.image = newImage
        
        UIGraphicsEndImageContext();
    }

    internal func drawArrow(start: CGPoint, end: CGPoint, onStart: Bool, onFinish: Bool) {
        self.drawArrow(start, end: end, onStart: onStart, onFinish: onFinish, tipLength: self.DEFAULT_TIP_LENGTH)
    }

    // draw arrow with bezier path curve
    // two control points define the curvature of the segment
    internal func drawBezierArrow(var start: CGPoint, var end: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint, onStart: Bool, onFinish: Bool, tipLength: CGFloat) {
        // Initialise
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        
        self.image!.drawInRect(self.bounds)
        
        //drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, self.lineWidth)
        
        self.color.setStroke();
        
        //move to start point at first
        CGContextMoveToPoint(context, start.x, start.y)
        
        if(onStart){
            let angle = self.pointPairToBearingDegrees(start, secondPoint:controlPoint1)
            
            let tipPoint = self.getArrowSidePoint(start, length:5, angle:angle - CGFloat((DEFAULT_TIP_ANGLE)))
            CGContextAddLineToPoint(context, tipPoint.x, tipPoint.y)
            
            CGContextMoveToPoint(context, start.x, start.y)
            // add first part of arrow's tip
            var arPoint = self.getArrowSidePoint(start, length:tipLength, angle:angle - CGFloat((DEFAULT_TIP_ANGLE*2)))
            CGContextAddLineToPoint(context, arPoint.x, arPoint.y)
            
            //move back to start
            CGContextMoveToPoint(context, start.x, start.y)
            // draw second part of tip
            arPoint = self.getArrowSidePoint(start, length:tipLength, angle:angle)
            CGContextAddLineToPoint(context, arPoint.x, arPoint.y)
            
            //redirect current start to draw bezier curve from top of arrow's tip
            start = tipPoint;
        }
        if(onFinish){
            CGContextMoveToPoint(context, end.x, end.y)
            
            let angle = self.pointPairToBearingDegrees(end, secondPoint:controlPoint2)
            
            let tipPoint = self.getArrowSidePoint(end, length:tipLength, angle:angle - CGFloat(DEFAULT_TIP_ANGLE))
            CGContextAddLineToPoint(context, tipPoint.x, tipPoint.y);
            
            CGContextMoveToPoint(context, end.x, end.y);
            // add first part of arrow's tip
            var arPoint = self.getArrowSidePoint(end, length:tipLength, angle:angle - CGFloat(DEFAULT_TIP_ANGLE*2))
            CGContextAddLineToPoint(context, arPoint.x, arPoint.y);
            
            //move back to end of line
            CGContextMoveToPoint(context, end.x, end.y);
            // draw second part of tip
            arPoint = self.getArrowSidePoint(end, length:tipLength, angle:angle)
            CGContextAddLineToPoint(context, arPoint.x, arPoint.y);
            
            //redirect current end to draw bezier curve from top of arrow's tip
            end = tipPoint;
        }
        
        
        // add bezier path
        let path = UIBezierPath()
        path.lineWidth = self.lineWidth
        
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1:controlPoint1, controlPoint2:controlPoint2)
        
        path.stroke()
        
        CGContextStrokePath(context);
        
        // Grab it as an autoreleased image
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        self.image = newImage
        
        UIGraphicsEndImageContext();
    }

    // bezier arrow with default tip length
    internal func drawBezierArrow(start: CGPoint, end: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint, onStart: Bool, onFinish: Bool) {
        self.drawBezierArrow(start, end: end, controlPoint1: controlPoint1, controlPoint2: controlPoint2, onStart: onStart, onFinish: onFinish, tipLength:DEFAULT_TIP_LENGTH)
    }

    // draw Pin Line with start and end points
    // triangle pin will not be added if triangleSize is bigger than line length from pin position
    // pin position in range 0.0 - 1.0
    internal func drawLine(start: CGPoint, end: CGPoint, pinTriangleSize: CGFloat, pinPosition: CGFloat) {
        // Initialise
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        
        self.image!.drawInRect(self.bounds)
        
        //drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, self.lineWidth)
        CGContextSetStrokeColorWithColor(context, self.color.CGColor)
        CGContextMoveToPoint(context, start.x, start.y)
        
        //[self pointPairToBearingDegrees:start secondPoint:end];
        let angle = self.pointPairToBearingDegrees(start, secondPoint:end)
        
        // calculate real line length
        var lineLenght = hypot((end.x - start.x), (end.y - start.y))
        if lineLenght < 0 {
            lineLenght -= lineLenght*2
        }
        
        // calculate length of line for pin setting
        let pinLine = lineLenght - pinTriangleSize
        let pinDistance = pinLine*pinPosition
        
        // pin triangle config
        if (lineLenght > pinDistance) && pinTriangleSize > 0 {
            
            // get first triangle extreme point
            var pinAngle = Float(angle).degreesToRadians
            
            // get first triangle extreme point
            var endX = CGFloat(cos(pinAngle)) * pinDistance + start.x
            var endY = CGFloat(sin(pinAngle)) * pinDistance + start.y
            
            let triangleStartPoint = CGPointMake(endX, endY)
            CGContextAddLineToPoint(context, triangleStartPoint.x, triangleStartPoint.y);
            
            // get top triangle point
            pinAngle =  Float(angle + 60).degreesToRadians // 60 degrees for equilateral triangle
            
            endX = cos(pinAngle) * pinTriangleSize + triangleStartPoint.x;
            endY = sin(pinAngle) * pinTriangleSize + triangleStartPoint.y;
            let triangleTopPoint = CGPointMake(endX, endY);
            CGContextAddLineToPoint(context, triangleTopPoint.x, triangleTopPoint.y);
            
            // get second triangle extreme point
            pinAngle = Float(angle).degreesToRadians
            endX = cos(pinAngle) * pinTriangleSize + triangleStartPoint.x;
            endY = sin(pinAngle) * pinTriangleSize + triangleStartPoint.y;
            
            let triangleLowPoint = CGPointMake(endX, endY);
            CGContextAddLineToPoint(context, triangleLowPoint.x, triangleLowPoint.y);
        }
        else{
            print("Pin Line: Pin can not be set with this configuration ")
        }
        
        CGContextAddLineToPoint(context, end.x, end.y);
        CGContextStrokePath(context);
        
        // Grab it as an autoreleased image
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        self.image = newImage
        
        UIGraphicsEndImageContext();
    }

    // draw Pin Line with default pin position
    internal func drawLine(start: CGPoint, end: CGPoint, pinTriangleSize: CGFloat) {
        self.drawLine(start, end:end, pinTriangleSize:pinTriangleSize, pinPosition:DEFAULT_PIN_POSITION)
    }

    // draw Pin Box with start and end bottom points
    // triangle pin will not be added if triangleSize is bigger than line length from pin position
    // pin position in range 0.0 - 1.0
    internal func drawPinBox(bottomStart:CGPoint, bottomEnd:CGPoint, pinTriangleSize:CGFloat, boxHeight:CGFloat, pinPosition:CGFloat) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        
        self.image!.drawInRect(self.bounds)
        
        //drawing code
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, self.lineWidth)
        CGContextSetStrokeColorWithColor(context, self.color.CGColor)
        CGContextMoveToPoint(context, bottomStart.x, bottomStart.y)
        
        let angle = self.pointPairToBearingDegrees(bottomStart, secondPoint:bottomEnd)
        
        var lineLenght = hypot((bottomEnd.x - bottomStart.x), (bottomEnd.y - bottomStart.y))
        if lineLenght < 0 {
            lineLenght -= lineLenght*2
        }
        
        // calculate length of line for pin setting
        let pinLine = lineLenght - pinTriangleSize;
        let pinDistance = pinLine*pinPosition;
        
        // pin triangle config
        if (pinTriangleSize < (lineLenght*(1-pinPosition))) && pinTriangleSize > 0 {
            
            // get first triangle extreme point
            var pinAngle = Float(angle).degreesToRadians
            
            var endX = cos(pinAngle) * pinDistance + bottomStart.x
            var endY = sin(pinAngle) * pinDistance + bottomStart.y
            let triangleStartPoint = CGPointMake(endX, endY)
            
            //move to pin start on line
            CGContextAddLineToPoint(context, triangleStartPoint.x, triangleStartPoint.y)
            
            // get top triangle point
            pinAngle = Float(angle + 60).degreesToRadians
            
            endX = CGFloat(cos(pinAngle)) * pinTriangleSize + triangleStartPoint.x
            endY = CGFloat(sin(pinAngle)) * pinTriangleSize + triangleStartPoint.y
            let triangleTopPoint = CGPointMake(endX, endY)
            CGContextAddLineToPoint(context, triangleTopPoint.x, triangleTopPoint.y)
            
            // get second triangle extreme point
            pinAngle =  Float(angle).degreesToRadians
            endX = cos(pinAngle) * pinTriangleSize + triangleStartPoint.x
            endY = sin(pinAngle) * pinTriangleSize + triangleStartPoint.y
            
            let triangleLowPoint = CGPointMake(endX, endY);
            CGContextAddLineToPoint(context, triangleLowPoint.x, triangleLowPoint.y)
        }
        else{
            print("Pin Box: Pin can not be set with this configuration ")
        }
        
        // draw line to last bottom point
        CGContextAddLineToPoint(context, bottomEnd.x, bottomEnd.y);
        
        // draw top corners of box
        let pinAngle = Float(angle - 90).degreesToRadians
        
        // draw line to first top corner
        var endX = CGFloat(cos(pinAngle)) * boxHeight + bottomEnd.x;
        var endY = CGFloat(sin(pinAngle)) * boxHeight + bottomEnd.y;
        let firstBoxCornerPoint = CGPointMake(endX, endY);
        CGContextAddLineToPoint(context, firstBoxCornerPoint.x, firstBoxCornerPoint.y);
        
        // move to first bottom point
        CGContextMoveToPoint(context, bottomStart.x, bottomStart.y);
        endX = CGFloat(cos(pinAngle)) * boxHeight + bottomStart.x;
        endY = CGFloat(sin(pinAngle)) * boxHeight + bottomStart.y;
        let secBoxCornerPoint = CGPointMake(endX, endY);
        // draw line to second top corner
        CGContextAddLineToPoint(context, secBoxCornerPoint.x, secBoxCornerPoint.y);
        //draw line between corner points
        CGContextAddLineToPoint(context, firstBoxCornerPoint.x, firstBoxCornerPoint.y);
        
        CGContextStrokePath(context);
        
        // Grab it as an autoreleased image
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        self.image = newImage
        
        UIGraphicsEndImageContext();
    }
    
    func getArrowSidePoint(start:CGPoint, length:CGFloat, angle:CGFloat) -> CGPoint {
        
        let arrowAngle = (Float(DEFAULT_TIP_ANGLE) + Float(angle)).degreesToRadians
        
        let endX = CGFloat(cos(arrowAngle)) * CGFloat(length) + CGFloat(start.x)
        let endY = CGFloat(sin(arrowAngle)) * CGFloat(length) + CGFloat(start.y)
        let point = CGPointMake(endX, endY);
        
        return point;
    }

//mark: - Math helpers

    func pointPairToBearingDegrees(startingPoint:CGPoint, secondPoint:CGPoint) -> CGFloat {
        let originPoint = CGPointMake(secondPoint.x - startingPoint.x, secondPoint.y - startingPoint.y)
        // get origin point to origin by subtracting end from start
        let bearingRadians = atan2f(Float(originPoint.y), Float(originPoint.x))
        // get bearing in radians
        var bearingDegrees = Double(bearingRadians) * (180.0 / M_PI)
        // convert to degrees
        bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees: (360.0 + bearingDegrees))
        
        // correct discontinuity
        //NSLog(@"angle between points: %@",@(bearingDegrees));
        
        return CGFloat(bearingDegrees);
    }
    
    func getPinTrianlgeStartPoint(start:CGPoint, end:CGPoint) -> CGPoint {
        
        let midPoint = CGPointMake((start.x + end.x)/2, (start.y + end.y)/2);
        
        return CGPointMake((start.x + midPoint.x)/2, (start.y + midPoint.y)/2);
    }
    
    func bezierInterpolation(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat) -> CGFloat {
        let t2 = t * t;
        let t3 = t2 * t;
        return a + (-a * 3 + t * (3 * a - a * t)) * t
            + (3 * b + t * (-6 * b + b * 3 * t)) * t
            + (c * 3 - c * 3 * t) * t2
            + d * t3;
    }

    func interpolationCoefficientWithLength(length:CGFloat, xCoord:CGFloat, controlPoint1:CGFloat, controlPoint2:CGFloat) -> CGFloat {
        
        var diff = 0 as CGFloat;
        
        if self.pointCloserToControlPoint(xCoord, controlPoint1: controlPoint1, controlPoint2: controlPoint2) {
            diff = xCoord - controlPoint1;
        } else{
            diff = xCoord - controlPoint2;
        }
        // coefficient = difference between closest points devided by 2 (middle)
        let coefficient = (diff/length)/2;
        
        return coefficient;
    }
    
    func pointCloserToControlPoint(pointX:CGFloat, controlPoint1:CGFloat, controlPoint2:CGFloat) -> Bool {
        let res1 = fabs(pointX - controlPoint1);
        let res2 = fabs(pointX - controlPoint2);
        
        return res1 < res2;
    }

}


