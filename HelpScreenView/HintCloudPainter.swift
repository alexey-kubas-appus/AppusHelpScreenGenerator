//
//  HintCloudPainter.swift
//  HelpScreenDemo
//
//  Created by Andrey Pervushin on 09.11.15.
//  Copyright © 2015 Appus. All rights reserved.
//

import UIKit

//Rectangle Point

@objc enum RectCorner:Int {
    case LeftTop, RightTop, RightBottom, LeftBottom, Center
}

extension CGRect {
    
    func corner(corner:RectCorner)->CGPoint{
        
        switch corner {
            
        case .LeftTop:
            return self.origin
            
        case .RightTop:
            return CGPoint(x: self.maxX, y: self.minY)
            
        case .RightBottom:
            return CGPoint(x: self.maxX, y: self.maxY)
            
        case .LeftBottom:
            return CGPoint(x: self.minX, y: self.maxY)
            
        case .Center:
            return CGPoint(x: CGRectGetMidX(self), y: CGRectGetMidY(self));
        }
    }
}

extension CGPoint {
    
    func vector() -> CGVector{
        return CGVectorMake(self.x, self.y)
    }
    
    func translate(vector:CGVector) -> CGPoint{
        
        return CGPoint(x: self.x + vector.dx, y: self.y + vector.dy)
        
    }
    
}

extension CGVector {
    
    init (start:CGPoint, end:CGPoint){
        
        self = CGVector(dx: end.x - start.x, dy: end.y - start.y)
        
    }
    
    init (scalar:Double, length:Double){
        
        self = CGVector(dx:cos(scalar) * length, dy: sin(scalar) * length)
        
    }
    
    func magnitude()->CGFloat{
        
        return sqrt( self.dx * self.dx + self.dy * self.dy)
    }

    
    func normalized()->CGVector {
        
        let length = self.magnitude()
        
        if(length > 0.0) {
            
            return CGVector(dx: self.dx / length, dy: self.dy / length)
            
        }else{
            return self
        }
        
    }
    
    func scaled(scale:CGFloat)->CGVector{
        
        return CGVector(dx: self.dx * scale, dy: self.dy * scale)
    }
    
    func angleInRadians() -> CGFloat {
        
        let normalizedVector = self.normalized()
        
        let theta = atan2(normalizedVector.dy, normalizedVector.dx)
        return theta + CGFloat(M_PI_2 * -1)
    }
    
    
    
    func rotate(degrees: CGFloat)->CGVector{
        
        return self.rotateRadians(degrees * CGFloat(M_PI/180.0))
        
    }
    
    func rotateRadians(radians: CGFloat)->CGVector{
        
        let ca = cos(radians)
        
        let sa = sin(radians)
        
        return CGVector(dx:ca * self.dx - sa * self.dy, dy:sa * self.dx + ca * self.dy)
    }
    
}


class HintCloudPainter: NSObject {
    
    func drawCloudWithHint(hint:Hint, imageView:HelperImageView){
        
        switch (self.detectBubbleForHint(hint)){

        case .Line:
            self.drawLineWithHint(hint, imageView: imageView)
            break
        case .PinBox:
            fallthrough
        default:
            self.drawPinBoxWithHint(hint, imageView: imageView)
            break
        }
        
    }
    
    func detectBubbleForHint(hint:Hint)->BubbleType{
  
        if (hint.bubbleType != .Auto){
            
            return hint.bubbleType
            
        }else{
            let targetFrame = hint.targetFrame
            
            let hintFrame = hint.hintContainer.frame
            
            if let type = self.bubbleTypeLineVsPinBox(
                hintFrame.corner(.RightTop).x,
                p2: targetFrame.corner(.LeftTop).x){
                    
                    return type
                    
            } else if let type = self.bubbleTypeLineVsPinBox(
                targetFrame.corner(.RightTop).x,
                p2: hintFrame.corner(.LeftTop).x){
                    
                    return type
                    
            } else if let type = self.bubbleTypeLineVsPinBox(
                targetFrame.corner(.LeftTop).y,
                p2: hintFrame.corner(.LeftBottom).y){
                    
                    return type
                    
            } else if let type = self.bubbleTypeLineVsPinBox(
                hintFrame.corner(.LeftBottom).y,
                p2: targetFrame.corner(.LeftTop).y){
                    
                    return type
                    
            }else{
                
                return .PinBox
                
            }
        }
    }
    
    func drawLineWithHint(hint:Hint, imageView:HelperImageView){
        
        let targetFrame = hint.targetFrame
        
        let hintFrame = hint.hintContainer.frame
        
        let centerVector = CGVector(start: targetFrame.corner(.Center), end: hintFrame.corner(.Center))
        
        var maxVector = CGVectorMake(0, 0)
        
        for i in 0...3{
            
            let v = CGVector(start: targetFrame.corner(.Center), end: hintFrame.corner(RectCorner.init(rawValue: i)!))

            if (v.magnitude() > maxVector.magnitude()){

                maxVector = v

            }
        
        }
        
        maxVector = maxVector.scaled(0.9)
        
        let clockvise = (maxVector.angleInRadians() - centerVector.angleInRadians()) > 0
        
        let  v1 = maxVector.rotate(clockvise ? 10: -10)
        
        let pt1 = targetFrame.corner(.Center).translate(v1)
        
        let pt2 = targetFrame.corner(.Center).translate(maxVector.rotate(clockvise ? 20: -20))
        
        let pt3 = targetFrame.corner(.Center).translate(maxVector.rotate(clockvise ? 35: -35).normalized().scaled(100))
        
        let v4 = CGVector(start: targetFrame.corner(.Center), end: pt3)
        
        let pt4 = targetFrame.corner(.Center).translate(v4.normalized().scaled(25))
        
        imageView.drawBezierArrow(pt1,
            end: pt4,
            controlPoint1: pt2,
            controlPoint2: pt3,
            onStart: false, onFinish: true)
        
    }
    
    func drawPinBoxWithHint(hint:Hint, imageView:HelperImageView){
        
        let targetFrame = hint.targetFrame
        
        let hintFrame = hint.hintContainer.frame
        
        let targetCenter = targetFrame.corner(.Center);
        
        let hintCenter = hintFrame.corner(.Center);
        
        let xCenterDistance = hintCenter.x - targetCenter.x
        
        let yCenterDistance = hintCenter.y - targetCenter.y
        
        let isHorizontalOut = abs(xCenterDistance) > (targetFrame.width + hintFrame.width) / 2
        
        let isVerticalOut = abs(yCenterDistance) > (targetFrame.height + hintFrame.height) / 2
        
        let barSize:CGFloat = 10
        
        
        //horizontal relation
        if isHorizontalOut && !isVerticalOut{
            
            let pinOffset = self.equatePinOffset(targetFrame, hintFrame: hintFrame)
            
            //Draw PinBox right from the target
            if (xCenterDistance > 0){
                
                imageView.drawPinBox(
                    hintFrame.corner(.LeftTop),
                    bottomEnd: hintFrame.corner(.LeftBottom),
                    pinTriangleSize: barSize,
                    boxHeight: hintFrame.width,
                    pinPosition: pinOffset)
                
                //Draw PinBox left from the target
            }else{
                
                imageView.drawPinBox(
                    hintFrame.corner(.RightBottom),
                    bottomEnd: hintFrame.corner(.RightTop),
                    pinTriangleSize: barSize,
                    boxHeight: hintFrame.width,
                    pinPosition: pinOffset)
                
            }
            
            //vertical relation
        }else if !isHorizontalOut && isVerticalOut{
            
            let pinOffset = self.equatePinOffset(targetFrame, hintFrame: hintFrame)
            
            //Draw PinBox bottom from the target
            if (yCenterDistance > 0){
                
                imageView.drawPinBox(
                    hintFrame.corner(.RightTop),
                    bottomEnd: hintFrame.corner(.LeftTop),
                    pinTriangleSize: barSize,
                    boxHeight: hintFrame.height,
                    pinPosition: pinOffset)
                
                //Draw PinBox top from the target
            }else{
                
                imageView.drawPinBox(
                    hintFrame.corner(.LeftBottom),
                    bottomEnd: hintFrame.corner(.RightBottom),
                    pinTriangleSize: barSize,
                    boxHeight: hintFrame.height,
                    pinPosition: pinOffset)
                
            }
            
        }
        
    }
    
    private func bubbleTypeLineVsPinBox(p1:CGFloat, p2:CGFloat)->BubbleType?{
        
        if p1 < p2 {
            
            if p2 - p1 > 30 {
                return .Line
            }else{
                return .PinBox
            }
        }else{
            return nil
        }
    }
    
    private func equatePinOffset(targetFrame:CGRect, hintFrame:CGRect)->CGFloat{
        
        let isRight = targetFrame.corner(.RightTop).x < hintFrame.corner(.LeftTop).x
        
        let isLeft = targetFrame.corner(.LeftTop).x > hintFrame.corner(.RightTop).x
        
        let isTop = targetFrame.corner(.LeftTop).y > hintFrame.corner(.LeftBottom).y
        
        let isBottom = targetFrame.corner(.LeftBottom).y < hintFrame.corner(.LeftTop).y
        
        //point from where drop perpendicular on line
        let v3 = targetFrame.corner(.Center)
        
        if isRight || isLeft {
            
            if (targetFrame.height < hintFrame.height){
                
                let v1 = hintFrame.corner(.LeftTop)
                
                let v2 = hintFrame.corner(.LeftBottom)
                
                let p = self.Perpendicular(v1.vector(), B: v2.vector(), C: v3.vector())
                
                let pinPoint = v3.translate(p)
                
                let pin = (pinPoint.y - hintFrame.corner(.LeftTop).y) / hintFrame.height
                
                return isRight ? pin : (1 - pin)
                
            }
            
        }
        
        if isTop || isBottom {
            
            if (targetFrame.width < hintFrame.width){
                
                let v1 = hintFrame.corner(.LeftTop)
                
                let v2 = hintFrame.corner(.RightTop)
                
                let p = self.Perpendicular(v1.vector(), B: v2.vector(), C: v3.vector())
                
                let pinPoint = CGPoint(x: v3.x + p.dx, y: v3.y + p.dy)
                
                let pin = (pinPoint.x -  hintFrame.corner(.LeftTop).x) / hintFrame.width
                
                return isTop ? pin : (1 - pin)
                
            }
            
        }
        
        
        return 0.5
    }
    
    
    //Vectors
    private func VDot(v1:CGVector, v2:CGVector)->CGFloat{
        return v1.dx * v2.dx + v1.dy * v2.dy
    }
    
    private func VMul(v1:CGVector, A:CGFloat)->CGVector{
        
        var v = v1
        v.dx *= A
        v.dy *= A
        
        return v
    }
    
    private func VSub(v1:CGVector,v2:CGVector)->CGVector{
        
        return CGVectorMake(v1.dx-v2.dx, v1.dy-v2.dy)
        
    }
    
    private func VProject(A:CGVector,B:CGVector)->CGVector{
        
        let aNorm = A.normalized()
        
        return VMul(aNorm, A: VDot(aNorm,v2: B));
        
    }
    
    //TODO: move to CGVector
    private func Perpendicular(A:CGVector,B:CGVector, C:CGVector)->CGVector{
        
        let CA = VSub(C, v2:A);
        
        return VSub( VProject( VSub(B, v2:A), B: CA), v2: CA);
    }
    
}
