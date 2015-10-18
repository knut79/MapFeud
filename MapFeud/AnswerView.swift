//
//  QuestionView.swift
//  MapFeud
//
//  Created by knut on 12/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class AnswerView: UIView {
    
    
    var answerText:UILabel!
    var infoText:UILabel!
    var infoButton:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()

        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapAnswer:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(singleTapGestureRecognizer)

        infoText = UILabel(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height  * 4))
        infoText.adjustsFontSizeToFitWidth = true
        infoText.textAlignment = NSTextAlignment.Center
        infoText.numberOfLines = 3
        infoText.font = UIFont.boldSystemFontOfSize(24)
        infoText.textColor = UIColor.blackColor()
        self.addSubview(infoText)
        
        answerText = UILabel(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height))
        answerText.adjustsFontSizeToFitWidth = true
        answerText.textAlignment = NSTextAlignment.Center
        answerText.font = UIFont.boldSystemFontOfSize(24)
        answerText.textColor = UIColor.whiteColor()
        self.addSubview(answerText)
        
        /*
        infoButton = UILabel(frame: CGRectMake( self.answerText.frame.maxX ,self.bounds.width * 0.01, self.bounds.width * 0.1,self.bounds.width * 0.1))
        infoButton.text = "ℹ"
        infoButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        infoButton.textAlignment = NSTextAlignment.Center
        infoButton.layer.borderWidth = 2
        infoButton.layer.cornerRadius = infoButton.bounds.size.width / 2
        infoButton.layer.masksToBounds = true
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapAnswer:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        infoButton.addGestureRecognizer(singleTapGestureRecognizer)
        self.addSubview(infoButton)
        */
    }
    
    var orgFrame:CGRect!
    var orgInfoFrame:CGRect!
    func tapAnswer(gesture:UITapGestureRecognizer)
    {
        let midscreen = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        if self.center == midscreen
        {
            //let heightRatio = imageView.image!.size.height / (self.bounds.height - 3)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.infoText.alpha = 0
                self.frame = self.orgFrame
                self.infoText.frame = self.orgInfoFrame
                }, completion: { (value: Bool) in
            })
            
        }
        else
        {
            orgFrame = self.frame
            orgInfoFrame = infoText.frame

            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.frame = UIScreen.mainScreen().bounds
                self.infoText.alpha = 1
                self.infoText.center = midscreen
                }, completion: { (value: Bool) in
            })
        }
        
        
    }
    
    
    func setAnswer(question:Question, distance:Int)
    {
        print("setQueston called")
        let template = question.answerTemplate.stringByReplacingOccurrencesOfString("$", withString: question.place.name, options: NSStringCompareOptions.LiteralSearch, range: nil)
        answerText.text = "\(distance) km \(template)"
        
        
        infoText.text = question.place.info
        infoText.alpha = 0
        
    }
}
