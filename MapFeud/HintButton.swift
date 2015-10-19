//
//  HintButton.swift
//  MapFeud
//
//  Created by knut on 12/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class HintButton: UIButton {
    
    var innerView:UILabel!
    var numberOfHints:UILabel!
    var orgFrame:CGRect!
    var hintsLeftOnQuestion:Int = 2
    var hintsLeftOnAccount:Int!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, hintsLeftOnAccount:Int) {
        super.init(frame: frame)
        
        self.hintsLeftOnAccount = hintsLeftOnQuestion
        innerView = UILabel(frame: CGRectMake(self.bounds.width * 0.1 ,self.bounds.width * 0.1, self.bounds.width * 0.8,self.bounds.width * 0.8))
        innerView.text = "❕"
        innerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        innerView.textAlignment = NSTextAlignment.Center
        innerView.layer.borderWidth = 2
        innerView.layer.cornerRadius = innerView.bounds.size.width / 2
        innerView.layer.masksToBounds = true
        self.addSubview(innerView)
        
        
        numberOfHints = UILabel(frame: CGRectMake(self.bounds.width * 0.6 ,self.bounds.width * 0.6, self.bounds.width * 0.4,self.bounds.width * 0.4))
        let hintsMiniIcon = hintsLeftOnAccount >= 2 ? "2" : "\(hintsLeftOnAccount)"
        if hintsLeftOnAccount == 0
        {
            numberOfHints.text = "+"
        }
        else
        {
            numberOfHints.text = "\(hintsMiniIcon)"
        }
        
        numberOfHints.backgroundColor = UIColor.blueColor()
        numberOfHints.adjustsFontSizeToFitWidth = true
        numberOfHints.textColor = UIColor.whiteColor()
        numberOfHints.layer.borderColor = UIColor.blueColor().CGColor
        numberOfHints.textAlignment = NSTextAlignment.Center
        numberOfHints.layer.borderWidth = 2
        numberOfHints.layer.cornerRadius = numberOfHints.bounds.size.width / 2
        numberOfHints.layer.masksToBounds = true
        self.addSubview(numberOfHints)
        //innerView.center = CGPointMake(margin + (hintButton.frame.width / 2) , UIScreen.mainScreen().bounds.height * 0.33)
        
    }
    

    func deductHints()
    {
        hintsLeftOnAccount!--
        hintsLeftOnQuestion--
        
        let hintsMiniIcon = hintsLeftOnAccount >= hintsLeftOnQuestion ? "\(hintsLeftOnQuestion)" : "\(hintsLeftOnAccount)"
        if hintsLeftOnAccount == 0
        {
            numberOfHints.text = "+"
        }
        else
        {
            numberOfHints.text = "\(hintsMiniIcon)"
        }
        
        numberOfHints.text = "\(hintsLeftOnQuestion)"
    }
    
    func restoreHints()
    {
        hintsLeftOnQuestion = 2
        numberOfHints.text = "\(hintsLeftOnQuestion)"
    }
    
    func isVisible() -> Bool
    {
        return self.frame == orgFrame
    }
    
    func hide(hide:Bool = true)
    {
        if hide
        {
            self.center = CGPointMake(self.frame.maxX * -1, self.center.y)
        }
        else
        {
            self.frame = self.orgFrame
        }
    }
}
