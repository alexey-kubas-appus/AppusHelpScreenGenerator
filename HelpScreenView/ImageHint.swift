//
//  ImageHint.swift
//  HelpScreenDemo
//
//  Created by Andrey Pervushin on 04.11.15.
//  Copyright © 2015 Appus. All rights reserved.
//

import UIKit

class ImageHint: Hint {
    
    var image:UIImage? = UIImage()
    
    var imageView:UIImageView = UIImageView()
//    Initializators for targetView
    convenience init(target:UIView!, image:UIImage, bubbleType:BubbleType, sizes:[NSValue]) {
        
        self.init(target:target, image:image, sizes:sizes)
        
        self.bubbleType = bubbleType
        
    }

    convenience init(target:UIView!, image:UIImage, bubbleType:BubbleType) {
        
        self.init(target:target, image:image)
        
        self.bubbleType = bubbleType
        
    }

    convenience init(target:UIView!, image:UIImage, imageContentMode:UIViewContentMode, bubbleType:BubbleType, sizes:[NSValue]) {

        self.init(target:target, image:image, imageContentMode:imageContentMode, sizes:sizes)

        self.bubbleType = bubbleType;
    }

    convenience init(target:UIView!, image:UIImage, imageContentMode:UIViewContentMode, bubbleType:BubbleType) {

        self.init(target:target, image:image, bubbleType:bubbleType)

        self.imageView.contentMode = imageContentMode

    }

    convenience init(target:UIView!, image:UIImage, imageContentMode:UIViewContentMode, sizes:[NSValue]) {

        self.init(target:target, image:image, sizes:sizes)

        self.imageView.contentMode = imageContentMode

    }

    convenience init(target:UIView!, image:UIImage, imageContentMode:UIViewContentMode) {
        self.init(target:target, image:image)

        self.imageView.contentMode = imageContentMode

    }

    convenience init(target:UIView!, image:UIImage, sizes:[NSValue]) {

        self.init(target:target, image:image)

        var sizesArray = [CGSize]()
        for value in sizes {
            sizesArray.append(value.CGSizeValue())
        }

        self.sizes = sizesArray

    }
//    Initializators for targetFrame
    convenience init(targetRect:CGRect, image:UIImage, bubbleType:BubbleType, sizes:[NSValue]) {
        self.init(target:nil, image:image, bubbleType:bubbleType,sizes:sizes)

        self.targetFrame = targetRect
    }

    convenience init(targetRect:CGRect, image:UIImage, bubbleType:BubbleType) {

        self.init(target:nil, image:image, bubbleType:bubbleType)

        self.targetFrame = targetRect
    }

    convenience init(targetRect:CGRect, image:UIImage, imageContentMode:UIViewContentMode, bubbleType:BubbleType, sizes:[NSValue]) {

        self.init(target:nil, image:image, imageContentMode:imageContentMode, bubbleType:bubbleType,sizes:sizes)

        self.targetFrame = targetRect
    }

    convenience init(targetRect:CGRect, image:UIImage, imageContentMode:UIViewContentMode, bubbleType:BubbleType) {

        self.init(target:nil, image:image, imageContentMode:imageContentMode,bubbleType:bubbleType)

        self.targetFrame = targetRect

    }

    convenience init(targetRect:CGRect, image:UIImage, imageContentMode:UIViewContentMode, sizes:[NSValue]) {

        self.init(target:nil, image:image, imageContentMode:imageContentMode, sizes:sizes)

        self.targetFrame = targetRect

    }

    convenience init(targetRect:CGRect, image:UIImage, imageContentMode:UIViewContentMode) {
        self.init(target:nil, image:image, imageContentMode:imageContentMode)

        self.targetFrame = targetRect

    }

    convenience init(targetRect:CGRect, image:UIImage, sizes:[NSValue]) {

        self.init(target:nil, image:image, sizes:sizes)

        self.targetFrame = targetRect

    }

    convenience init(targetRect:CGRect, image:UIImage) {
        self.init(target:nil, image:image)
        self.targetFrame = targetRect
    }

    
    init(target:UIView!, image:UIImage){
        
        super.init()
        
        self.target = target
        
        self.hintContainer = self.imageView
        
        self.imageView.image = image
        
        self.imageView.contentMode = .ScaleToFill
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.userInteractionEnabled = true
        
    }
    
    override func equateSizes()->[CGSize]{
        
        var sizes = [CGSize]()
        
        sizes.append(CGSize(width: 50,height: 50))
        
        return sizes
        
    }
    
}
