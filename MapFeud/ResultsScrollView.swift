//
//  ResultsScrollView.swift
//  PlaceInTime
//
//  Created by knut on 17/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class ResultsScrollView: UIView , UIScrollViewDelegate{
    
    var items:[ResultItemView]!
    var scrollView:UIScrollView!
    var totalResultLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let margin:CGFloat = 0
        let topLevelTitleWidth:CGFloat = (self.bounds.width - (margin * 2)) / 2
        let titleElementHeight:CGFloat = 40
        
        let myScoreLabel = ResultTitleLabel(frame: CGRectMake(margin , margin, topLevelTitleWidth, titleElementHeight))
        myScoreLabel.textAlignment = NSTextAlignment.Center
        myScoreLabel.text = "Me"

        
        self.addSubview(myScoreLabel)
        
        
        let opponentsScoreLabel = ResultTitleLabel(frame: CGRectMake(myScoreLabel.frame.maxX , margin, topLevelTitleWidth, titleElementHeight))
        opponentsScoreLabel.textAlignment = NSTextAlignment.Center
        opponentsScoreLabel.text = "Opponent"
        self.addSubview(opponentsScoreLabel)
        
        let secondLevelTitleWidth:CGFloat = (self.bounds.width - ( margin * 2)) / 4
        
        let myStateLabel = ResultTitleLabel(frame: CGRectMake(margin , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myStateLabel.textAlignment = NSTextAlignment.Center
        myStateLabel.text = "Result"
        self.addSubview(myStateLabel)
        
        let usingKm = NSUserDefaults.standardUserDefaults().boolForKey("useKm")
        
        let myDistanceLabel = ResultTitleLabel(frame: CGRectMake(myStateLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myDistanceLabel.textAlignment = NSTextAlignment.Center
        myDistanceLabel.text = usingKm ? "Km" : "Miles"
        self.addSubview(myDistanceLabel)
        
        
        
        let opponentNameLabel = ResultTitleLabel(frame: CGRectMake(myDistanceLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentNameLabel.textAlignment = NSTextAlignment.Center
        opponentNameLabel.text = "Name"
        self.addSubview(opponentNameLabel)
        
        
        let opponentDistanceLabel = ResultTitleLabel(frame: CGRectMake(opponentNameLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentDistanceLabel.textAlignment = NSTextAlignment.Center
        opponentDistanceLabel.text = usingKm ? "Km" : "Miles"
        self.addSubview(opponentDistanceLabel)
        
        
        
        
        totalResultLabel = UILabel(frame: CGRectMake(margin ,self.bounds.height - titleElementHeight , self.bounds.width, titleElementHeight))
        totalResultLabel.textAlignment = NSTextAlignment.Left
        
        totalResultLabel.text = "    Victories 0 Losses 0 😐"
        //totalResultLabel.layer.borderColor = UIColor.whiteColor().CGColor
        //totalResultLabel.layer.borderWidth = 2.0
        totalResultLabel.adjustsFontSizeToFitWidth = true
        totalResultLabel.backgroundColor = UIColor.blueColor()
        totalResultLabel.textColor = UIColor.whiteColor()
        self.addSubview(totalResultLabel)
        
        
        
        
        scrollView = UIScrollView(frame: CGRectMake(0, opponentDistanceLabel.frame.maxY, self.bounds.width, self.bounds.height - opponentDistanceLabel.frame.maxY - totalResultLabel.frame.height))
        
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 5.0
        

        items = []
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, 0)
        
        self.addSubview(scrollView)
        
    }
    
    
    func addItem(myDistance:Int,opponentName:String,opponentDistance:Int, title:String, date:String)
    {
        let itemheight:CGFloat = 40
        
        let newItem = ResultItemView(frame: CGRectMake(0, 0, self.frame.width, itemheight),myDistance:myDistance,opponentName:opponentName,opponentDistance:opponentDistance, title:title, date:date)
        items.insert(newItem, atIndex: 0)
        scrollView.addSubview(newItem)
        
        
        /*
        contentHeight = layoutResult(0)
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
        */
        
    }
    
    func layoutResult(var index:Int, var contentHeight:CGFloat = 0)
    {
        if items.count > index
        {
            let item = items[index]
            /*
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                item.frame = CGRectMake(0, item.frame.height * CGFloat(index), self.frame.width, item.frame.height)
                contentHeight = item.frame.maxY
                }, completion: { (value: Bool) in
                    index++
                    self.layoutResult(index,contentHeight: contentHeight)
            })
            */
            item.frame = CGRectMake(0, item.frame.height * CGFloat(index), self.frame.width, item.frame.height)
            contentHeight = item.frame.maxY
            index++
            self.layoutResult(index,contentHeight: contentHeight)
            
        }
        else
        {
            scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
        }
        
        
    }
    
    func setResultText()
    {
        var wins:Int = 0
        var losses:Int = 0
        for item in items
        {
            if item.stateWin == 1
            {
                wins++
            }
            else if item.stateLoss == 1
            {
                losses++
            }
        }
        let icon:String = {
            if wins > 0 && losses == 0
            {
                return "😎"
            }
            else if wins > losses
            {
                return "😀"
            }
            else if losses > wins
            {
                return "😞"
            }
            else
            {
                return "😐"
            }
        }()
        totalResultLabel.text = "    Victories \(wins) Losses \(losses) \(icon)"
    }
    
}