//
//  TagCheckView.swift
//  TimeIt
//
//  Created by knut on 06/08/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

protocol RadiobuttonItemProtocol
{
    func uncheckAll()
}

class RadiobuttonItemView: UIView
{
    var radiobutton:UIButton!
    var titleLabel:UILabel!
    var checked = true
    var title:String!
    var value:NSDictionary!
    var delegate:RadiobuttonItemProtocol!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, title:String,value:NSDictionary, checked:Bool = true) {
        super.init(frame: frame)
        
        self.checked = checked
        radiobutton = UIButton(frame: CGRectMake(0, 0, frame.width * 0.33, frame.height))
        if self.checked
        {
            radiobutton.setTitle("🔘", forState: UIControlState.Normal)
        }
        else
        {
            radiobutton.setTitle("⚪️", forState: UIControlState.Normal)
        }
        radiobutton.addTarget(self, action: "toggleSelect:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(radiobutton)
        
        self.title = title
        self.value = value
        titleLabel = UILabel(frame: CGRectMake(radiobutton.frame.maxX, 0, frame.width * 0.66, frame.height))
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.text = title
        self.addSubview(titleLabel)
        
    }
    
    func toggleSelect(sender:UIButton)
    {
        delegate?.uncheckAll()
        

        checked = true
        radiobutton.setTitle("🔘", forState: UIControlState.Normal)
    }
    
    func uncheck()
    {
        checked = false
        radiobutton.setTitle("⚪️", forState: UIControlState.Normal)
    }
    
}

