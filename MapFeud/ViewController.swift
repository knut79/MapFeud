//
//  ViewController.swift
//  MapFeud
//
//  Created by knut on 05/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {//, MapDelegate {

    var datactrl:DataHandler!
    var map:MapScrollView!
    var playerIcon:PlayerIconView!
    var magnifyingGlass: MagnifyingGlassView!
    var magnifyingGlassLeftPos:CGPoint!
    var magnifyingGlassRightPos:CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map = MapScrollView(frame: UIScreen.mainScreen().bounds)
        //map.delegate = self
        
        playerIcon = PlayerIconView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 0.12, UIScreen.mainScreen().bounds.width * 0.12))
        playerIcon.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        playerIcon.userInteractionEnabled = true
        map.addSubview(playerIcon)
        
        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapMap:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        map.addGestureRecognizer(singleTapGestureRecognizer)
        
        self.view.addSubview(map)
        
        let magnifyingSide = UIScreen.mainScreen().bounds.width * 0.22
        magnifyingGlass = MagnifyingGlassView(frame: CGRectMake( 0 , 0 ,magnifyingSide , magnifyingSide))
        magnifyingGlassLeftPos = CGPointMake(magnifyingSide , magnifyingSide)
        magnifyingGlassRightPos = CGPointMake(UIScreen.mainScreen().bounds.width - magnifyingSide , magnifyingSide)
        magnifyingGlass.center = magnifyingGlassLeftPos
        magnifyingGlass.mapToMagnify = map
        magnifyingGlass.alpha = 0
        self.view.addSubview(magnifyingGlass)
        
        setupButtons()
        
        populateDataIfNeeded()
    }
    
    func setupButtons()
    {
    }
    
    func populateDataIfNeeded()
    {
        if Int(datactrl.dataPopulatedValue as! NSNumber) <= 0
        {
            
            DataHandler().populateData({ () in
                
                
                //self.loadingDataView.alpha = 0
                //self.loadingDataView.layer.removeAllAnimations()
                self.afterPopulateData()
            })
            
            //loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        }
        else
        {
            afterPopulateData()
        }
    }
    
    func afterPopulateData()
    {
        datactrl.fetchData()
        let southAfricaTestExcluded = datactrl.fetchPlace("South Africa")
        //map.drawPlace(datactrl.placeItems[0])
        map.drawPlace(southAfricaTestExcluded!)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInView(self.view)
        
        let isInnView = CGRectContainsPoint(playerIcon!.frame,touchLocation)
        if(isInnView)
        {
            magnifyingGlass.center = touchLocation
            playerIcon.center = touchLocation
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.magnifyingGlass.alpha = 1
                    self.magnifyingGlass.center = self.magnifyingGlassRightPos
                    self.magnifyingGlass.transform = CGAffineTransformIdentity
                    self.playerIcon.transform = CGAffineTransformScale(self.playerIcon.transform, 1.3, 1.3)
                }, completion: { (value: Bool) in
            })
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first //touches.anyObject()
        let touchLocation = touch!.locationInView(self.view)
        let isInnView = CGRectContainsPoint(playerIcon.frame,touchLocation)
        let isInnMagnifyingView = CGRectContainsPoint(magnifyingGlass.frame,touchLocation)
        
        if(isInnMagnifyingView)
        {
            if self.magnifyingGlass.center == magnifyingGlassLeftPos
            {
                self.magnifyingGlass.center = magnifyingGlassRightPos
            }
            else
            {
                self.magnifyingGlass.center = magnifyingGlassLeftPos
            }
        }
        else if(isInnView)
        {
            playerIcon.alpha = 0
            magnifyingGlass.setTouchPoint(touchLocation)
            magnifyingGlass.setNeedsDisplay()
            
            let point = touches.first!.locationInView(self.view) //touches.anyObject()!.locationInView(self.view)
            //playerIcon.center = CGPointMake(point.x - xOffset, point.y - yOffset)
            playerIcon.center = CGPointMake(point.x , point.y)
        }
        else
        {

            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.playerIcon.alpha = 1
                self.magnifyingGlass.alpha = 0
                self.magnifyingGlass.center = touchLocation
                self.magnifyingGlass.transform = CGAffineTransformScale(self.magnifyingGlass.transform, 0.1, 0.1)
                self.playerIcon.transform = CGAffineTransformIdentity
                }, completion: { (value: Bool) in
            })
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first//touches.anyObject()
        let touchLocation = touch!.locationInView(self.view)
        playerIcon.alpha = 1
        let isInnView = CGRectContainsPoint(self.playerIcon!.frame,touchLocation)
        if(isInnView)
        {
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.magnifyingGlass.alpha = 0
                self.magnifyingGlass.center = touchLocation
                self.magnifyingGlass.transform = CGAffineTransformScale(self.magnifyingGlass.transform, 0.1, 0.1)
                self.playerIcon.transform = CGAffineTransformIdentity
                }, completion: { (value: Bool) in
            })
        }
    }
    
    func tapMap(gesture:UITapGestureRecognizer)
    {
        let touchLocation = gesture.locationInView(self.map)
        playerIcon.center = touchLocation
        
        self.playerIcon.transform = CGAffineTransformScale(self.playerIcon.transform, 1.3, 1.3)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.playerIcon.transform = CGAffineTransformIdentity
            }, completion: { (value: Bool) in
        })
    }
    
    //MARK MapDelegate
    /*
    func resolutionChanged()
    {
        magnifyingGlass.viewToMagnify = map.scrollView
    }
*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

