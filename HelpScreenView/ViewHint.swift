//
//  ViewHint.swift
//  HelpScreenDemo
//
//  Created by Andrey Pervushin on 05.11.15.
//  Copyright © 2015 Appus. All rights reserved.
//

import UIKit

class ViewHint: Hint {
    
    var originalViewSize:CGSize!
    
    convenience init(target:UIView!, view:UIView, bubbleType:BubbleType, sizes:[NSValue]) {
        
        self.init(target:target, view:view, sizes:sizes)
        
        self.bubbleType = bubbleType
        
    }
    
    convenience init(target:UIView!, view:UIView, bubbleType:BubbleType) {
        
        self.init(target:target, view:view)
        
        self.bubbleType = bubbleType
        
    }
    
    convenience init(target:UIView!, view:UIView, sizes:[NSValue]) {
        
        self.init(target:target, view:view)

        var sizesArray = [CGSize]()
        for value in sizes {
            sizesArray.append(value.CGSizeValue())
        }

        self.sizes = sizesArray
        
    }
//    Initializators for targetFrame

    convenience init(targetRect:CGRect, view:UIView, bubbleType:BubbleType) {
        self.init(target:nil, view:view, bubbleType:bubbleType)

        self.targetFrame = targetRect
    }

    convenience init(targetRect:CGRect, view:UIView, bubbleType:BubbleType, sizes:[NSValue]) {

        self.init(target:nil, view:view, bubbleType:bubbleType, sizes:sizes)

        self.targetFrame = targetRect

    }

    convenience init(targetRect:CGRect, view:UIView, sizes:[NSValue]) {
        self.init(target:nil, view:view, sizes:sizes)

        self.targetFrame = targetRect
    }

    convenience init(targetRect:CGRect, view:UIView) {
        self.init(target:nil, view:view)

        self.targetFrame = targetRect
    }
    
    init(target:UIView!, view:UIView){
        
        super.init()
        
        view.removeFromSuperview()
        
        self.target = target
        
        self.hintContainer = view
        
        self.hintContainer.translatesAutoresizingMaskIntoConstraints = false
        
        self.originalViewSize = self.hintContainer.frame.size
        
    }
    
    override func equateSizes()->[CGSize]{
        
        return [self.originalViewSize]
        
    }

}
