//
// Created by Sergey Sokoltsov on 11/27/15.
// Copyright (c) 2015 Appus. All rights reserved.
//

import UIKit

public extension UIView {
//rect
//x,y - relative coords
//size - size of gradient rect (width/2 = radius)
    public func addGradientHole(point:(CGPoint), width:(CGFloat)) {

        let rect = CGRectMake(point.x, point.y, width, 0)
        let array = [rect]
        self.addGradientHoles(array);
    }

    // NSArray of NSValue-s
    public func addGradientHoles(array:[CGRect]) {
        let finalImage = self.createFromArray(array)
        let maskLayer = CALayer()
        maskLayer.contents = finalImage.CGImage
        maskLayer.frame = self.bounds
        self.layer.mask = maskLayer
    }

    func createFromArray(array:[CGRect]) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.layer.bounds.size, false, 1)
        let gradLocationsNum = 2 as size_t
        let gradLocations:[CGFloat] = [0.0, 1.0]
        let gradColors:[CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0]

        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        //draw background at first

        CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, CGPointMake(0, 0), 0, CGPointMake(0, 0), 0.0001, .DrawsAfterEndLocation)

        
        // set blend mode for multiple radials

        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), .SourceIn);

        for rect in array {
            let center = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.width/2)
            let radius = rect.size.width/2

            CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, center, 0, CGPointMake(center.x, center.y), radius, .DrawsBeforeStartLocation);
        }


        // Grab it as an autoreleased image
        let image = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return image;

    }

//      Gradient Rects

    public func addGradientWithRect(rect:(CGRect)) {
        var longerWidth = true
        if rect.size.width < rect.size.height {
            longerWidth = false
        }

        let finalImage = self.createGradientImageWithRect(rect, widthLonger:longerWidth)
        let maskLayer = CALayer()
        maskLayer.contents = finalImage.CGImage;
        maskLayer.frame = self.bounds;

        self.layer.mask = maskLayer;
    }

    public func addGradientWithRectsArray(array:[CGRect]) {
        let finalImage = self.createGradientImageWithRectsArray(array);
        let maskLayer = CALayer()
        maskLayer.contents = finalImage.CGImage;
        maskLayer.frame = self.bounds;

        self.layer.mask = maskLayer;
    }

    // HEIGHT defines Radius here (radius = CGRect.size.height)

    func createGradientImageWithRect(rect:CGRect, widthLonger:Bool) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.layer.bounds.size, false, 3);

        let gradLocationsNum = 2 as size_t
        let gradLocations:[CGFloat] = [0.0, 1.0]
        let gradColors:[CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0]

        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);

        //draw background at first

        CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, CGPointMake(0, 0), 0, CGPointMake(0, 0), 0.0001, .DrawsAfterEndLocation)

        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), .SourceIn);

        var radius = rect.size.height/2

        if widthLonger {
            rect.size.width
            
            for var i = 0; i < Int(rect.size.width - rect.size.height + 1); ++i {
                let center =  CGPointMake(rect.origin.x + radius + CGFloat(i), rect.origin.y + radius)
                CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, center, 0, CGPointMake(center.x, center.y), radius, .DrawsBeforeStartLocation)
            }
        } else {
            radius = rect.size.width/2
            for var i = 0; i < Int(rect.size.height - rect.size.width + 1); ++i {
                let center = CGPointMake(rect.origin.x + radius , rect.origin.y + radius + CGFloat(i))
                CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, center, 0, CGPointMake(center.x, center.y), radius, .DrawsBeforeStartLocation);
            }
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    func createGradientImageWithRectsArray(array:[CGRect]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.layer.bounds.size, false, 3);

        let gradLocationsNum = 2 as size_t
        let gradLocations:[CGFloat] = [0.0, 1.0]
        let gradColors:[CGFloat] = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0]

        let colorSpace = CGColorSpaceCreateDeviceRGB();
        let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);

        //draw background at first

        CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, CGPointMake(0, 0), 0, CGPointMake(0, 0), 0.0001, .DrawsAfterEndLocation)

        // set blend mode for multiple radials
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), .SourceIn);

        for rect in array {
            var longerWidth = true
            if rect.size.width < rect.size.height{
                longerWidth = false;
            }

            var radius = rect.size.height/2

            if longerWidth {
                for var i = 0; i < Int(rect.size.width - rect.size.height + 1); ++i {
                    let center =  CGPointMake(rect.origin.x + radius + CGFloat(i), rect.origin.y + radius)
                    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, center, 0, CGPointMake(center.x, center.y), radius, .DrawsBeforeStartLocation)
                }
            } else {
                radius = rect.size.width/2
                for var i = 0; i < Int(rect.size.height - rect.size.width + 1); ++i {
                    let center = CGPointMake(rect.origin.x + radius , rect.origin.y + radius + CGFloat(i))
                    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), gradient, center, 0, CGPointMake(center.x, center.y), radius, .DrawsBeforeStartLocation);
                }
            }
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image
    }

}
