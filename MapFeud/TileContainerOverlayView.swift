//
//  TileContainerOverlayView.swift
//  MapFeud
//
//  Created by knut on 08/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class TileContainerOverlayLayer: CALayer {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        super.init()
    }
    
    var regions:[[LinePoint]] = []
    var exludedRegions:[[LinePoint]] = []
    var resolutionPercentage:CGFloat = 100
    var zoomScale:CGFloat = 1
    func drawLines(regions:[[LinePoint]],excludedRegions:[[LinePoint]], resolutionPercentage:CGFloat, zoomScale:CGFloat)
    {
        self.regions = regions
        self.exludedRegions = excludedRegions
        self.resolutionPercentage = resolutionPercentage
        self.zoomScale = zoomScale
        self.setNeedsDisplay()
    }
    
    /*
    override func drawInContext(ctx: CGContext)
    {
        print("1  --- \(frame.width) ) - \(frame.height)")

        CGContextSetLineCap(ctx, CGLineCap.Round)
        CGContextSetLineJoin(ctx, CGLineJoin.Round)
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1)
        CGContextSetRGBFillColor(ctx, 1.0, 0.0, 0.0, 1.0)
        //CGContextSetFillColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetRGBFillColor(ctx, 0, 200, 0, 0.5);
        
        drawMask(ctx)
        drawTest(ctx)
    }
*/
    
    

    override func drawInContext(ctx: CGContext)
    {
        //CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), originalImage.CGImage)
        //originalImage.drawInRect(CGRectMake(0, 0, originalImage.size.width, originalImage.size.height))
        CGContextSetLineCap(ctx, CGLineCap.Round)
        CGContextSetLineJoin(ctx, CGLineJoin.Round)
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1)
        CGContextSetRGBFillColor(ctx, 1.0, 0.0, 0.0, 1.0)
        CGContextSetFillColorWithColor(ctx, UIColor.blackColor().CGColor)
        
        //drawMask(ctx)

        
        drawPlace(ctx)
        
        //CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.75);
        //[self StrokeUpRegions:loc andContextRef:context];
        //[self StrokeUpExludedRegions:loc andContextRef:context];
        //CGContextRestoreGState(context);
        
    }
    
    func drawMask(context:CGContext)
    {
        //let maskImage = UIImage(named: "25MaskWater.png" )
        let maskImage = UIImage(named: "25MaskWater.png" )
        //let maskImageScaled = UIImage(CGImage: maskImage!.CGImage!, scale: zoomScale, orientation: UIImageOrientation.Up)
        let sacleSize = CGSizeMake(maskImage!.size.width * zoomScale, maskImage!.size.height * zoomScale)
        UIGraphicsBeginImageContextWithOptions(sacleSize, false, 0.0);
        maskImage!.drawInRect(CGRectMake(0, 0, sacleSize.width, sacleSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        let maskRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, self.frame.height)
        let mask: CGImageRef = CGImageMaskCreate(CGImageGetWidth(resizedImage.CGImage), CGImageGetHeight(resizedImage.CGImage), CGImageGetBitsPerComponent(resizedImage.CGImage), CGImageGetBitsPerPixel(resizedImage.CGImage), CGImageGetBytesPerRow(resizedImage.CGImage), CGImageGetDataProvider(resizedImage.CGImage), nil, false)!
        //let mask: CGImageRef = CGImageMaskCreate(CGImageGetWidth(maskImage!.CGImage), CGImageGetHeight(maskImage!.CGImage), CGImageGetBitsPerComponent(maskImage!.CGImage), CGImageGetBitsPerPixel(maskImage!.CGImage), CGImageGetBytesPerRow(maskImage!.CGImage), CGImageGetDataProvider(maskImage!.CGImage), nil, false)!

        CGContextClipToMask(context, maskRect, mask)
    }
    
    func drawPlace(context:CGContext)
    {
        for lines in regions
        {
            CGContextBeginPath(context)
            
            let pathRef:CGMutablePathRef = CGPathCreateMutable()
            let firstPoint = lines[0]
            CGPathMoveToPoint(pathRef,nil, CGFloat(firstPoint.x) * (resolutionPercentage / 100.0) , CGFloat(firstPoint.y) * (resolutionPercentage / 100.0) )
            
            for var i = 1 ; i < lines.count ; i++
            {
                let line = lines[i] //as! LinePoint
                print("x \(line.x) ) y \(line.y)")
                CGPathAddLineToPoint(pathRef, nil, CGFloat(line.x) * (resolutionPercentage / 100.0) , CGFloat(line.y) * (resolutionPercentage / 100.0) )
                //CGContextAddLineToPoint(context, CGFloat(line.x) * (resolutionPercentage / 100.0) * zoomScale, CGFloat(line.y) * (resolutionPercentage / 100.0) * zoomScale)
            }
            
            //CGContextStrokePath(context)
            //CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
            
            CGPathCloseSubpath(pathRef)
            CGContextAddPath(context, pathRef)
            
            //CGContextClosePath(context)
            //CGContextFillPath(context)
        }

        for lines in exludedRegions
        {
            //CGContextBeginPath(context)
            
            let pathRef:CGMutablePathRef = CGPathCreateMutable()
            let firstPoint = lines[0] //as! LinePoint
            CGPathMoveToPoint(pathRef,nil, CGFloat(firstPoint.x) * (resolutionPercentage / 100.0), CGFloat(firstPoint.y) * (resolutionPercentage / 100.0) )

            
            //CGContextMoveToPoint(context, CGFloat(firstPoint.x) * (resolutionPercentage / 100.0) * zoomScale, CGFloat(firstPoint.y) * (resolutionPercentage / 100.0) * zoomScale)
            for var i = 1 ; i < lines.count ; i++
            {
                let line = lines[i] //as! LinePoint
                print("x \(line.x) ) y \(line.y)")
                CGPathAddLineToPoint(pathRef, nil, CGFloat(line.x) * (resolutionPercentage / 100.0) , CGFloat(line.y) * (resolutionPercentage / 100.0) )
                //CGContextAddLineToPoint(context, CGFloat(line.x) * (resolutionPercentage / 100.0) * zoomScale, CGFloat(line.y) * (resolutionPercentage / 100.0) * zoomScale)
            }
            
            //CGContextStrokePath(context)
            //CGContextDrawPath(context, CGPathDrawingMode.FillStroke)
            
            CGPathCloseSubpath(pathRef)
            CGContextAddPath(context, pathRef)
            
            CGContextClosePath(context)
        
        }

        CGContextEOFillPath(context)
    }
    
    func drawTest(context:CGContext )
    {
        CGContextBeginPath(context)
        let pathRef:CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(pathRef,nil, CGFloat(0), CGFloat(0))
        CGPathAddLineToPoint(pathRef, nil, CGFloat(bounds.maxX), CGFloat(0))
        CGPathAddLineToPoint(pathRef, nil, CGFloat(bounds.maxX), CGFloat(bounds.maxY))
        CGPathAddLineToPoint(pathRef, nil, CGFloat(0), CGFloat(bounds.maxY))
        CGPathCloseSubpath(pathRef)
        CGContextAddPath(context, pathRef)
        CGContextFillPath(context)
    }
    
}
