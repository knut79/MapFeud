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
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        innerView = UILabel(frame: CGRectMake(self.bounds.width * 0.1 ,self.bounds.width * 0.1, self.bounds.width * 0.8,self.bounds.width * 0.8))
        innerView.text = "❕"
        innerView.layer.borderColor = UIColor.lightGrayColor().CGColor
        innerView.textAlignment = NSTextAlignment.Center
        innerView.layer.borderWidth = 2
        innerView.layer.cornerRadius = innerView.bounds.size.width / 2
        innerView.layer.masksToBounds = true
        self.addSubview(innerView)
        
        
        numberOfHints = UILabel(frame: CGRectMake(self.bounds.width * 0.6 ,self.bounds.width * 0.6, self.bounds.width * 0.4,self.bounds.width * 0.4))
        numberOfHints.text = "2"
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
}
