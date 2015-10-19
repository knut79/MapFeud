//
//  QuestionView.swift
//  MapFeud
//
//  Created by knut on 12/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class QuestionView: UIView {
    
    
    var questionText:UILabel!
    var imageView:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        questionText = UILabel(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height))
        questionText.adjustsFontSizeToFitWidth = true
        questionText.textAlignment = NSTextAlignment.Center
        questionText.font = UIFont.boldSystemFontOfSize(24)
        questionText.textColor = UIColor.whiteColor()
        self.addSubview(questionText)
        
        imageView = UIImageView(frame: CGRectZero)
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        imageView.userInteractionEnabled = true
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapFlag:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        imageView.addGestureRecognizer(singleTapGestureRecognizer)
        self.addSubview(imageView)
        
    }
    
    var orgFrame:CGRect!
    var orgImageFrame:CGRect!
    var orgTextPosition:CGPoint!
    func tapFlag(gesture:UITapGestureRecognizer)
    {
        let midscreen = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        if self.center == midscreen
        {
           //let heightRatio = imageView.image!.size.height / (self.bounds.height - 3)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.frame = self.orgFrame
                self.imageView.frame = self.orgImageFrame
                self.questionText.center = self.orgTextPosition
                }, completion: { (value: Bool) in
                    
                    
            })
            
        }
        else
        {
            //orgFrame = self.frame
            orgImageFrame = imageView.frame
            orgTextPosition = questionText.center
            let widthRatio = (UIScreen.mainScreen().bounds.width - 20) / imageView.frame.width
            let imageWidth = UIScreen.mainScreen().bounds.width - 20
            let imageheight = imageView.frame.height * widthRatio
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.frame = UIScreen.mainScreen().bounds
                    self.imageView.frame = CGRectMake(0, 0, imageWidth, imageheight)
                    self.imageView.center = midscreen
                    self.questionText.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, self.questionText.center.y)
                }, completion: { (value: Bool) in
                    
                    
            })
        }

        
    }
    
    
    func setQuestion(question:Question)
    {
        print("setQueston called")
        questionText.text = "\(question.text)?"
        if question.image != ""
        {
            if let image = UIImage(named: question.image)
            {
                imageView.alpha = 1
                imageView.image = image
                let heightRatio = image.size.height / (self.bounds.height - 3)
                imageView.frame = CGRectMake(3, 3, image.size.width / heightRatio, self.bounds.height - 6)
                questionText.frame = CGRectMake(imageView.frame.maxX + 3, 0, self.bounds.width - imageView.frame.width - 9, self.bounds.height)
            }
        }
        else
        {
            imageView.alpha = 0
            questionText.frame = CGRectMake(3, 0, self.bounds.width - 6, self.bounds.height)
        }
    }
    
    func isVisible() -> Bool
    {
        return self.frame == orgFrame
    }
    
    func hide(hide:Bool = true)
    {
        if hide
        {
            self.center = CGPointMake(self.center.x, self.frame.maxY * -1)
        }
        else
        {
            self.frame = self.orgFrame
        }
        
    }
}
