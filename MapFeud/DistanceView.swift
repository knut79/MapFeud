//
//  DistanceView.swift
//  MapFeud
//
//  Created by knut on 18/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit


class DistanceView: UIView {
    
    var distance:Int = 0
    var distanceLabel:UILabel!
    var orgFrame:CGRect!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()

        distanceLabel = UILabel(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height))
        distanceLabel.adjustsFontSizeToFitWidth = true
        distanceLabel.text = "0 km"
        distanceLabel.textAlignment = NSTextAlignment.Center
        distanceLabel.font = UIFont.boldSystemFontOfSize(24)
        distanceLabel.textColor = UIColor.whiteColor()
        self.addSubview(distanceLabel)

    }

    func addDistance(dist:Int)
    {
        self.distance = self.distance + dist
        self.distanceLabel.text = "\(self.distance) km"
        
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        pulseAnimation.duration = 0.3
        pulseAnimation.toValue = NSNumber(float: 0.3)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true;
        pulseAnimation.repeatCount = 5
        pulseAnimation.delegate = self
        distanceLabel.layer.addAnimation(pulseAnimation, forKey: "whatever")
        
    }

    func isVisible() -> Bool
    {
        return self.frame == orgFrame
    }
    
    func hide(hide:Bool = true)
    {
        if hide
        {
            if isVisible()
            {
                self.center = CGPointMake(self.center.x, UIScreen.mainScreen().bounds.maxY + self.frame.height)
            }
        }
        else
        {
            self.frame = self.orgFrame
        }
    }
    
}

