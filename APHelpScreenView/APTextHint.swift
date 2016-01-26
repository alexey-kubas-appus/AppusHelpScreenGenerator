//
//  APTextHint.swift
//  HelpScreenDemo
//
//  Created by Andrey Pervushin on 04.11.15.
//  Copyright © 2015 Appus. All rights reserved.
//

import UIKit

class APTextHint: APHint {
    
    var text:String?
    
    private var labelContainerView = UIView();
    private var label = UILabel()

//    Initializators for targetView
    convenience init(target: UIView!, text: String, bubbleType: BubbleType, sizes: [NSValue]) {

        self.init(target: target, text: text, sizes: sizes)

        self.bubbleType = bubbleType

    }

    convenience init(target: UIView!, text: String, bubbleType: BubbleType) {

        self.init(target: target, text: text)

        self.bubbleType = bubbleType

    }

    convenience init(target: UIView!, text: String, sizes: [NSValue]) {

        self.init(target: target, text: text)

        var sizesArray = [CGSize]()
        for value in sizes {
            sizesArray.append(value.CGSizeValue())
        }

        self.sizes = sizesArray
    }

//    Initializators for targetFrame
    convenience init(targetRect:CGRect, text:String) {
        self.init(target:nil, text:text)
        self.targetFrame = targetRect;
    }

    convenience init(targetRect:CGRect, text:String, sizes:[NSValue]) {
        self.init(target:nil, text:text, sizes:sizes)
        self.targetFrame = targetRect;
    }

    convenience init(targetRect: CGRect, text: String, bubbleType: BubbleType) {
        self.init(target:nil, text:text, bubbleType:bubbleType);
        self.targetFrame = targetRect;
    }

    convenience init(targetRect:CGRect, text:String, sizes:[NSValue], bubbleType: BubbleType) {
        self.init(target:nil, text:text, bubbleType:bubbleType, sizes:sizes)
        self.targetFrame = targetRect;
    }
    
    init(target:UIView!, text:String){
        
//        if !target.isKindOfClass(UIView) {
//            print("Error! target should be UIView")
//        }
        
        super.init()
        
        self.target = target
        
        self.labelContainerView.addSubview(self.label);
        
        self.applyConstraintsForLabelFromRect(self.label)
        
        self.hintContainer = self.labelContainerView
        
        self.label.font = UIFont(name: "Chalkduster", size:20)
        
        self.label.text = text

        self.label.textAlignment = .Center
        
        self.label.numberOfLines = 0
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        self.label.minimumScaleFactor = 0.1
        
        self.label.adjustsFontSizeToFitWidth = true
        
        self.label.textColor = UIColor.whiteColor()
        
        self.label.userInteractionEnabled = true
        
    }
    
    func applyConstraintsForLabelFromRect(object:UIView){
        self.labelContainerView.addConstraints([
            NSLayoutConstraint(
                item: self.labelContainerView,
                attribute: NSLayoutAttribute.Bottom,
                relatedBy: NSLayoutRelation.Equal,
                toItem: object,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: 5),
            
            NSLayoutConstraint(
                item: self.labelContainerView,
                attribute: NSLayoutAttribute.Trailing,
                relatedBy: NSLayoutRelation.Equal,
                toItem: object,
                attribute: NSLayoutAttribute.Trailing,
                multiplier: 1,
                constant: 5),
            NSLayoutConstraint(
                item: self.labelContainerView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: object,
                attribute: .Leading,
                multiplier: 1,
                constant: -5),
            
            NSLayoutConstraint(
                item: self.labelContainerView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: object,
                attribute: .Top,
                multiplier: 1,
                constant: -5),
            ])
    }
    
    override func equateSizes()->[CGSize]{
        
        var sizes = [CGSize]()
        
        let baseSize = label.sizeThatFits(CGSize(width: Int.max, height: Int.max))
        
        let st = NSString(string: self.label.text!)
        
        if (st.length < 35){
            
            sizes.append(baseSize)
            
        }
        
        for i in 2...6 {
            
            let index = CGFloat(i)
            
            var candidatSize :CGSize
            
            var j = 0
            
            repeat{
                
                let width = baseSize.width/index + CGFloat(j) * CGFloat(20.0)
                
                candidatSize = CGSize(width: width, height: CGFloat.max)
                
                candidatSize = label.sizeThatFits(candidatSize)
                
                j++
                
            }while candidatSize.height > baseSize.height * index
            
            sizes.append(candidatSize)
            
        }
        
        
        
        return sizes
        
    }
    
}
