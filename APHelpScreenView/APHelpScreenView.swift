//
//  HelpScreenView.swift
//  HelpScreenDemo
//
//  Created by Andrey Pervushin on 02.11.15.
//  Copyright © 2015 Appus. All rights reserved.
//

import UIKit


@objc protocol APHelpScreenViewDelegate {
    
    /**
     Used to get tapped hint, if tapped outside of any hint, hint is nil
     */
    func didTapHint(helpScreenView: APHelpScreenView, hint: APHint?)
    
}

@objc protocol APHelpScreenViewDataSource {
    
    /**
     Required for hint with .Custom hint position, must provide rect in bounds of HelpScreenView
     */
    func rectForHint(helpScreenView: APHelpScreenView, hint: APHint, atIndex:Int)->CGRect
    
    /**
     - returns: number of hints in data source
     */
    func numberOfHints(helpScreenView: APHelpScreenView)->Int
    
    
    /**
     - returns: child Hint class instanse
     */
    func hintForIndex(helpScreenView: APHelpScreenView, index:Int)-> APHint

    /**
     - returns view which should be blurred
    */
    func viewForBlurring() -> UIView

}


/**
 HelpScreenView - class for easy creating tutorials and help screens
 */
class APHelpScreenView: UIView {
    
    var hints :[APHint]?

    var backgroundImageView = APHelperImageView()
    
    var delegate: APHelpScreenViewDelegate! = nil
    
    var dataSource: APHelpScreenViewDataSource! = nil
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.setup()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.userInteractionEnabled = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didTapHintContainer:"))
        
    }
    
    /**
     Update all components position and repaint help screen
     */
    func reloadData()->Void{
        
        self.resetLayout()
        
        self.hints = self.reorderedHints()
        
        self.setupGestures()
        
        //Update target frames
        
        for hint in self.hints! {
            hint.convertTragetFrameToView(self)
            self.addSubview(hint.hintContainer)
        }
        
        //Get positions for hints
        
        for (var i = 0; i < self.hints!.count; i++) {
            
            let hint = self.hints![i]
            
            var hintRect = hint.targetFrame
            
            //Auto positioning, calculate all possible positions, and use proper one
            
            if hint.hintPosition == .Auto {
                
                for tempRect in hint.equateRectangles(self.bounds){
                    
                    if (self.canBePlaced(tempRect)){
                        hintRect = tempRect
                        break
                    }
                    
                }
                
                //Custom positioning, developer must provide CGRect for this hint
            }else{
                
                if self.dataSource != nil{
                    
                    hintRect = self.dataSource.rectForHint(self, hint:hint, atIndex: i)
                }
                
            }
            
            hint.hintContainer.frame = hintRect
            
            APHint.applyConstraintsFromRect(hint.hintContainer, rect: hintRect)
            
        }
        
        self.setNeedsLayout()
        
        self.drawArrows()
        
    }
    
    
    /**
     Any UIView defined with IB as HelpScreenView class can be used for showing hints
     if HelpScreenView ctreated with code, use this method to add help screen to view hierarchy
     
     - parameter superView: basicaly this is window
     */
    func addToView(superView:UIView){
        
        superView.addSubview(self)
        
        self.frame = superView.bounds
        
        superView.addConstraints([
            
            NSLayoutConstraint(
                item: self,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: superView,
                attribute: .Leading,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: self,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: superView,
                attribute: .Top,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: self,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: superView,
                attribute: .Trailing,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: self,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: superView,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0)
            
            ])
        
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        self.frame = self.superview!.bounds
    }
    
    private func resetLayout(){
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        for (var i = 0; i < self.dataSource!.numberOfHints(self); i++) {
            
            let control = self.dataSource!.hintForIndex(self, index: i)
            
            control.hintContainer.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            
            for constraint in control.hintContainer.constraints{
                
                if (constraint.firstAttribute == .Width || constraint.firstAttribute == .Height) && constraint.secondItem == nil{
                    control.hintContainer.removeConstraint(constraint)
                }
                
            }
            
            for constraint in self.constraints{
                
                if constraint.firstItem as! UIView == control.hintContainer{
                    
                    self.removeConstraint(constraint)
                    
                }
            }
        }
    }
    
    /**
     A bit tricky method to improve auto placing algorithm, first iterating hints from the beginig next from the end to center
     */
    private func reorderedHints()->[APHint]{
        
        let itemsCount = self.dataSource!.numberOfHints(self)
        
        var indexes = [APHint]()

        for (var i = itemsCount - 1; i >= 0; i--){

            if i > itemsCount / 2 - 1 {

                indexes.append(self.dataSource!.hintForIndex(self, index: i))

            }else{

                indexes.insert(self.dataSource!.hintForIndex(self, index: i), atIndex: 0)

            }

        }
        
        return indexes
        
    }
    
    private func canBePlaced(tempHintRect:CGRect)->Bool{
        
        for hint in self.hints! {
            
            //check for conflicts with targets
            if CGRectIntersectsRect(tempHintRect, hint.targetFrame) {
                
                return false
                
            }
            
            //check for conflicts with labels
            
            let testFrame = hint.hintContainer.frame
            
            if CGRectIntersectsRect(tempHintRect, testFrame){
                
                return false
                
            }
            
        }
        
        return true
        
    }
    
    
    /**
     Prepare background image and redraw all clouds and arrows
     */
    private func drawArrows(){
        
        self.backgroundImageView.frame = self.bounds


        if let view = self.dataSource?.viewForBlurring() {

            self.backgroundImageView.backgroundColor = UIColor.clearColor()

            UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 1)

            view.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: false)

            let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()

            let image = screenshot.applyBlurWithRadius(2, tintColor: UIColor(white: 0, alpha: 0.65), saturationDeltaFactor: 1)

            self.backgroundImageView.image = image
        } else {
            self.backgroundImageView.backgroundColor = UIColor(white: 0,alpha: 0.75)
            self.backgroundImageView.image = UIImage();
        }
        
        self.insertSubview(self.backgroundImageView, atIndex: 0)
        
        var targetRects = [CGRect]()
        
        for hint in self.hints! {
            
            APHintCloudPainter().drawCloudWithHint(hint, imageView: self.backgroundImageView)
            
            //add some padding to make dots on targets better
            
            let offset:CGFloat = 10
            
            
            targetRects.append(CGRect(
                x: hint.targetFrame.origin.x - offset,
                y: hint.targetFrame.origin.y - offset,
                width: hint.targetFrame.width + offset * 2,
                height: hint.targetFrame.height + offset * 2))
        }
        
        self.backgroundImageView.addGradientWithRectsArray(targetRects)
        
    }
    
    private func setupGestures(){
        
        for hint in self.hints! {
            
            if (hint.tapGesture == nil){
                
                hint.tapGesture = UITapGestureRecognizer(target: self, action: "didTapHintContainer:")
                
                hint.hintContainer.addGestureRecognizer(hint.tapGesture!)
                
            }
        }
    }
    
    /**
     Detect tapped hint and send it to delegate method
     */
    func didTapHintContainer(recognizer:UITapGestureRecognizer){
        
        if (self.delegate != nil && self.hints != nil){
            
            for hint in self.hints! {
                
                if hint.hintContainer == recognizer.view{
                    
                    self.delegate!.didTapHint(self, hint: hint)
                    
                    return
                }
            }
            
            self.delegate!.didTapHint(self, hint: nil)
        }
        
    }
    
    
}
