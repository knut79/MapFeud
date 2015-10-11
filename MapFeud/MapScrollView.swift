//
//  MapScrollView.swift
//  MapFeud
//
//  Created by knut on 05/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit


protocol MapDelegate
{
    func resolutionChanged()
    
}


class MapScrollView:UIView, UIScrollViewDelegate  {
    
    
    var tileContainerView:TileContainerView!
    var scrollView:UIScrollView!
    
    let constMapHeight:CGFloat = 2944
    let constMapWidth:CGFloat = 4096
    let maxTileSize:CGFloat = 256
    
    let minimumResolution:Int = -2
    let maximumResolution:Int = 1
    var resolution:Int = -2
    
    var delegate:MapDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tileContainerView = TileContainerView(frame: CGRectZero)

        //overlayDrawView.backgroundColor = UIColor.clearColor()
        
/*
        let maskImage = UIImage(named: "25MaskLand.png" )
        let mask = CALayer()
        mask.contents = maskImage!.CGImage
        mask.frame = overlayDrawView.frame
        overlayDrawView.layer.addSublayer(mask)
        overlayDrawView.layer.mask = mask
*/
        tileContainerView.autoresizesSubviews = true
        tileContainerView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleBottomMargin]
        //overlayDrawView.autoresizesSubviews = true
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height))
        scrollView.autoresizesSubviews = true
        
        let resolutionPercentage = 100 * pow(Double(2), Double(resolution))
        let mapWith:CGFloat =  constMapWidth * (CGFloat(resolutionPercentage) / 100.0)
        let mapHeight:CGFloat =  constMapHeight * (CGFloat(resolutionPercentage) / 100.0)
        
        
        self.scrollView.addSubview(tileContainerView)
        
        
    
        tileContainerView.frame = CGRectMake(0, 0, mapWith, mapHeight)
        
        
        
        setupTiles()
        
        
        scrollView.contentSize = tileContainerView.bounds.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = max(scaleWidth, scaleHeight)
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 2.9
        scrollView.zoomScale = minScale
        
        self.addSubview(scrollView)
        
    }
    
    var placesToDraw:[[LinePoint]] = []
    var placesToExcludeDraw:[[LinePoint]] = []
    var overlayDrawView:TileContainerOverlayLayer?
    func drawPlace(place:Place)
    {
        //test
        let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
        let excludedPlace = datactrl.fetchPlace(place.excludePlaces)
        
        print("drawing \(place.name)")
        //let resolutionPercentage = 100 * pow(Double(2), Double(resolution))
        placesToDraw = []
        placesToDraw.append(place.sortedPoints)
        
        placesToExcludeDraw = []
        placesToExcludeDraw.append(excludedPlace!.sortedPoints)
        
        //overlayDrawView?.resolutionPercentage = resolutionPercentage
        overlayDrawView?.exludedRegions = placesToExcludeDraw
        overlayDrawView?.regions = placesToDraw
        overlayDrawView?.setNeedsDisplay()
        

        //overlayDrawView.drawLines(regions,excludedRegions: excludedRegions, resolutionPercentage: CGFloat(resolutionPercentage), zoomScale: scrollView.zoomScale)
    }
    
    func setupTiles()
    {

        /*
        for view in tileContainerView.subviews {
            view.removeFromSuperview()
        }
*/
        if tileContainerView.layer.sublayers?.count > 0
        {
            for layer in tileContainerView.layer.sublayers! {
                layer.removeFromSuperlayer()
            }
        }
        
        
        // The resolution is stored as a power of 2, so -1 means 50%, -2 means 25%, and 0 means 100%.
        let resolutionPercentage = 100 * pow(Double(2), Double(resolution));
        print("resolution : \(resolutionPercentage)")
        let mapWith:CGFloat =  constMapWidth * (CGFloat(resolutionPercentage) / 100.0)
        let mapHeight:CGFloat =  constMapHeight * (CGFloat(resolutionPercentage) / 100.0)

        //tileContainerView.frame = CGRectMake(0, 0, mapWith, mapHeight)
        let maxRow:Int = Int(ceil(mapHeight / maxTileSize))
        let maxColumn:Int = Int(ceil(mapWith / maxTileSize))
        for var row = 0 ; row < maxRow ; row++
        {
            for var col = 0 ; col < maxColumn ; col++
            {
                let imageName = "world_\(Int(resolutionPercentage))_\(col)_\(row).jpg"
                
                let tileImage = UIImage(named: imageName)

                if let image = tileImage
                {
                    let layer = CALayer()
                    layer.frame = CGRectMake(CGFloat(col) * maxTileSize, CGFloat(row) * maxTileSize, image.size.width, image.size.height)
                    layer.contents = tileImage?.CGImage //UIImage(named: "star")?.CGImage
                    layer.contentsGravity = kCAGravityCenter
                    tileContainerView.layer.addSublayer(layer)
                    
                    //let tileImageView = UIImageView(image:image)
                    //tileImageView.frame = CGRectMake(CGFloat(col) * maxTileSize, CGFloat(row) * maxTileSize, image.size.width, image.size.height)
                    //tileContainerView.addSubview(tileImageView)
                }
                else
                {
                    print("Did not find file \(imageName)")
                }
                
            }
        }
        
        
        overlayDrawView = TileContainerOverlayLayer()
        overlayDrawView!.frame = CGRectMake(0, 0, mapWith, mapHeight)
        overlayDrawView!.contentsGravity = kCAGravityCenter
        tileContainerView.layer.addSublayer(overlayDrawView!)
        
        overlayDrawView!.regions = placesToDraw
        overlayDrawView!.exludedRegions = placesToExcludeDraw
        overlayDrawView!.resolutionPercentage = CGFloat(resolutionPercentage)
        
        
        overlayDrawView!.setNeedsDisplay()
        
        delegate?.resolutionChanged()

    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func updateResolution()
    {
        // delta will store the number of steps we should change our resolution by. If we've fallen below
        // a 25% zoom scale, for example, we should lower our resolution by 2 steps so delta will equal -2.
        // (Provided that lowering our resolution 2 steps stays within the limit imposed by minimumResolution.)
        var delta:Int = 0
        
        // check if we should decrease our resolution
        for var thisResolution = minimumResolution; thisResolution < resolution; thisResolution++
        {
            let thisDelta:Int = thisResolution - resolution
            // we decrease resolution by 1 step if the zoom scale is <= 0.5 (= 2^-1); by 2 steps if <= 0.25 (= 2^-2), and so on
            let scaleCutoff = pow(CGFloat(2), CGFloat(thisDelta))
            if self.scrollView.zoomScale <= scaleCutoff
            {
                delta = thisDelta
                break
            }
        }
        
        // if we didn't decide to decrease the resolution, see if we should increase it
        if delta == 0
        {
            for var thisResolution = maximumResolution; thisResolution > resolution; thisResolution--
            {
                let thisDelta:Int = thisResolution - resolution
                // we increase by 1 step if the zoom scale is > 1 (= 2^0); by 2 steps if > 2 (= 2^1), and so on
                let scaleCutoff:CGFloat = pow(CGFloat(2), CGFloat(thisDelta - 1))
                if self.scrollView.zoomScale > scaleCutoff
                {
                    delta = thisDelta
                    break
                }
            }
        }
        
        
        if delta != 0
        {
            resolution += delta
            
            // if we're increasing resolution by 1 step we'll multiply our zoomScale by 0.5; up 2 steps multiply by 0.25, etc
            // if we're decreasing resolution by 1 step we'll multiply our zoomScale by 2.0; down 2 steps by 4.0, etc
            let zoomFactor:CGFloat = pow(CGFloat(2), CGFloat(delta * -1))
            
            // save content offset, content size, and tileContainer size so we can restore them when we're done
            // (contentSize is not equal to containerSize when the container is smaller than the frame of the scrollView.)
            
            let contentOffset:CGPoint = self.scrollView.contentOffset
            
            let contentSize:CGSize = self.scrollView.contentSize
            let containerSize:CGSize = self.tileContainerView.frame.size

            
            // adjust all zoom values (they double as we cut resolution in half)
            self.scrollView.maximumZoomScale = self.scrollView.maximumZoomScale * zoomFactor
            self.scrollView.minimumZoomScale = self.scrollView.minimumZoomScale * zoomFactor
            self.scrollView.zoomScale = self.scrollView.zoomScale * zoomFactor
            
            // restore content offset, content size, and container size
            
            self.scrollView.contentOffset = contentOffset
            
            self.scrollView.contentSize = contentSize
            self.tileContainerView.frame = CGRectMake(0, 0, contentSize.width, containerSize.height)
            
            //[tileContainerView setFrame:CGRectMake(0, 0, containerSize.width, containerSize.height)];
            
            // throw out all tiles so they'll reload at the new resolution
            //[self reloadData];
            
            self.setupTiles()

        }
    }
    

    //MARK scrollview delegate
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        /*
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        tileContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
            scrollView.contentSize.height * 0.5 + offsetY)
        */
        
        //overlayDrawView.zoomScale = scrollView.zoomScale
        //overlayDrawView.setNeedsDisplay()
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func synchronized<L: NSLocking>(lockable: L, criticalSection: () -> ()) {
        lockable.lock()
        criticalSection()
        lockable.unlock()
    }
    
    let lock = NSLock()
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        
        //print("zoomscale \(self.scrollView.zoomScale)")
        //print("zoomscale \(scale)")
        

        //synchronized(lock) {
            
            
            self.updateResolution()
        
        //}
        
        

    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return tileContainerView
    }
    
    
    
    
    
}