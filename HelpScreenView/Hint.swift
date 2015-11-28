//
//  Hint.swift
//  HelpScreenDemo
//
//  Created by Andrey Pervushin on 04.11.15.
//  Copyright © 2015 Appus. All rights reserved.
//

import UIKit


@objc enum HintPosition:Int{
    
    case Auto,Custom
    
}

@objc enum BubbleType:Int{
    
    case Auto, Line, PinBox
    
}

class Hint: NSObject {
    
    var target:UIView!
    
    var targetFrame = CGRect(x: 0,y: 0,width: 0,height: 0)
    
    var hintContainer:UIView!
    
    var showHole:Bool = true
    
    var hintPosition:HintPosition = .Auto
    
    var bubbleType:BubbleType = .Auto
    
    var tapGesture:UITapGestureRecognizer?
    
    internal var sizes = [CGSize]()
    
    
    func equateSizes()->[CGSize]{
        return [CGSize(width: 80, height: 50)]
    }
    
    func convertTragetFrameToView(view:UIView){
        if self.target == nil && self.targetFrame != CGRectZero {
            self.targetFrame = view.convertRect(self.targetFrame, toView:view)
        } else if self.target.respondsToSelector(Selector("superview")) {
            self.targetFrame = self.target!.superview!.convertRect(self.target!.frame, toView: view)
        }    }

    func equateRectangles(helperViewBounds:CGRect) -> [CGRect] {
        
        if self.sizes.count == 0{
            
            self.sizes = self.equateSizes()
            
        }

        return self.equateRectangles(helperViewBounds, controlRect:self.targetFrame, sizes: self.sizes)
        
    }

    private func equateRectangles(helperViewBounds:CGRect, controlRect:CGRect, sizes:[CGSize])->[CGRect]{
        
        var list = [CGRect]()

        let boundsRectWithInsets = CGRectMake(5,20,helperViewBounds.size.width - 10, helperViewBounds.size.height - 25);
        
        for candidatSize in sizes{
            
            //offset
            for i in 2...8{
                
                let offset = CGFloat(i * 10)
                var rect = controlRect;
                if rect.origin.x < boundsRectWithInsets.origin.x {
                    rect.origin.x = boundsRectWithInsets.origin.x
                }
                if rect.origin.y < boundsRectWithInsets.origin.y {
                    rect.origin.y = boundsRectWithInsets.origin.y
                }
                let horizontalOffset = rect.origin.x+rect.size.width - (boundsRectWithInsets.origin.x + boundsRectWithInsets.size.width);
                if horizontalOffset > 0  {
                    rect.size.width = rect.size.width - horizontalOffset
                }
                let verticalOffset = rect.origin.x+rect.size.width - (boundsRectWithInsets.origin.x + boundsRectWithInsets.size.width);
                if verticalOffset > 0  {
                    rect.size.height = rect.size.height - horizontalOffset
                }

                //top, align right
                let topRightRect = CGRect(
                x: rect.origin.x + rect.width - rect.width,
                        y: rect.origin.y - candidatSize.height - offset,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, topRightRect){
                    list.append(topRightRect)
                }
                //top, align left
                let topLeftRect = CGRect(
                x: rect.origin.x,
                        y: rect.origin.y - candidatSize.height - offset,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, topLeftRect){
                    list.append(topLeftRect)
                }

                //top, align center
                let topCenterRect = CGRect(
                x: rect.origin.x + rect.width / 2 - candidatSize.width / 2,
                        y: rect.origin.y - candidatSize.height - offset,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, topCenterRect){
                    list.append(topCenterRect)
                }

                //left, align bottom
                let leftBottomRect = CGRect(
                x: rect.origin.x - candidatSize.width - offset,
                        y: rect.origin.y,
                        width: candidatSize.width,
                        height: candidatSize.height)

                if  CGRectContainsRect(boundsRectWithInsets, leftBottomRect){
                    list.append(leftBottomRect)
                }

                //left, align top
                let leftTopRect = CGRect(
                x: rect.origin.x - candidatSize.width - offset,
                        y: rect.origin.y + rect.height - candidatSize.height,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, leftTopRect){
                    list.append(leftTopRect)
                }

                //bottom, align right
                let bottomRightRect = CGRect(
                x: rect.origin.x + rect.width - candidatSize.width,
                        y: rect.origin.y + rect.height + offset,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, bottomRightRect){
                    list.append(bottomRightRect)
                }

                //bottom, align left
                let bottomLeftRect = CGRect(
                x: rect.origin.x,
                        y: rect.origin.y + rect.height + offset,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, bottomLeftRect){
                    list.append(bottomLeftRect)
                }

                //bottom, align center
                let bottomCenterRect = CGRect(
                x: rect.origin.x + rect.width / 2 - candidatSize.width / 2,
                        y: rect.origin.y + rect.height + offset,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, bottomCenterRect){
                    list.append(bottomCenterRect)
                }

                //right, align bottom
                let rightBottomRect = CGRect(
                x: rect.origin.x + rect.width + offset,
                        y: rect.origin.y,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, rightBottomRect){
                    list.append(rightBottomRect)
                }

                //right, align top
                let rightTopCenter = CGRect(
                x: rect.origin.x + rect.width + offset,
                        y: rect.origin.y + rect.height - candidatSize.height,
                        width: candidatSize.width,
                        height: candidatSize.height)
                if  CGRectContainsRect(boundsRectWithInsets, rightTopCenter){
                    list.append(rightTopCenter)
                }
            }
            
        }
        
        return list
        
    }
    
    static func applyConstraintsFromRect(object:UIView, rect:CGRect){
        
        object.addConstraints([
            NSLayoutConstraint(
                item: object,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: rect.height),
            
            NSLayoutConstraint(
                item: object,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: rect.width)
            ])
        
        object.superview!.addConstraints([
            
            NSLayoutConstraint(
                item: object,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: object.superview,
                attribute: .Leading,
                multiplier: 1,
                constant: rect.origin.x),
            
            NSLayoutConstraint(
                item: object,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: object.superview,
                attribute: .Top,
                multiplier: 1,
                constant: rect.origin.y),
            
            ])
    }
    
}
