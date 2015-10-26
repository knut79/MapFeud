//
//  HintsView.swift
//  MapFeud
//
//  Created by knut on 26/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

protocol StatsViewProtocol
{
    func removeAds()
}

class StatsView: UIView {
    
    
    var hintsLeftText:UILabel!
    var versionText:UILabel!
    let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
    var delegate:StatsViewProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 1
        self.layer.masksToBounds = true
        
        let labelWidth = (self.bounds.width * 0.8) / 2
        let margin = self.bounds.width * 0.05
        hintsLeftText = UILabel(frame: CGRectMake(margin, 0, labelWidth, self.bounds.height))
        let hints = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")

        hintsLeftText.text = hints < 1 ? "Add hints ➕" : "Hints left: \(hints) ➕"
        hintsLeftText.adjustsFontSizeToFitWidth = true
        hintsLeftText.textAlignment = NSTextAlignment.Center
        hintsLeftText.font = UIFont.boldSystemFontOfSize(24)
        hintsLeftText.textColor = UIColor.blackColor()
        hintsLeftText.userInteractionEnabled = true
        let singleTapGestureRecognizerHints = UITapGestureRecognizer(target: self, action: "addHints:")
        singleTapGestureRecognizerHints.numberOfTapsRequired = 1
        singleTapGestureRecognizerHints.enabled = true
        singleTapGestureRecognizerHints.cancelsTouchesInView = false
        hintsLeftText.addGestureRecognizer(singleTapGestureRecognizerHints)
        self.addSubview(hintsLeftText)
        
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        if adFree == false
        {
            versionText = UILabel(frame: CGRectMake(hintsLeftText.frame.maxX + (margin * 2), 0, labelWidth, self.bounds.height))
            versionText.text = "Remove ads ➕"
            versionText.adjustsFontSizeToFitWidth = true
            versionText.textAlignment = NSTextAlignment.Center
            versionText.font = UIFont.boldSystemFontOfSize(24)
            versionText.textColor = UIColor.blackColor()
            versionText.userInteractionEnabled = true
            let singleTapGestureRecognizerVersion = UITapGestureRecognizer(target: self, action: "buyAdFree:")
            singleTapGestureRecognizerVersion.numberOfTapsRequired = 1
            singleTapGestureRecognizerVersion.enabled = true
            singleTapGestureRecognizerVersion.cancelsTouchesInView = false
            versionText.addGestureRecognizer(singleTapGestureRecognizerVersion)
            self.addSubview(versionText)
        }
        
    }
    
    func addHints(gesture:UITapGestureRecognizer)
    {
        var hints = NSUserDefaults.standardUserDefaults().integerForKey("hintsLeftOnAccount")
        hints++
        hintsLeftText.text = "Hints left: \(hints) ➕"
        NSUserDefaults.standardUserDefaults().setInteger(hints, forKey: "hintsLeftOnAccount")
        NSUserDefaults.standardUserDefaults().synchronize()
        datactrl.hintsValue = hints
        datactrl.saveGameData()
    }
    
    
    func buyAdFree(gesture:UITapGestureRecognizer)
    {
        versionText.removeFromSuperview()
        datactrl.adFreeValue = 1
        datactrl.saveGameData()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "adFree")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        delegate?.removeAds()
    }

}