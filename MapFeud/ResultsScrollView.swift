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
        myScoreLabel.text = "My score"

        
        self.addSubview(myScoreLabel)
        
        
        let opponentsScoreLabel = ResultTitleLabel(frame: CGRectMake(myScoreLabel.frame.maxX , margin, topLevelTitleWidth, titleElementHeight))
        opponentsScoreLabel.textAlignment = NSTextAlignment.Center
        opponentsScoreLabel.text = "Opponent score"
        self.addSubview(opponentsScoreLabel)
        
        let secondLevelTitleWidth:CGFloat = (self.bounds.width - ( margin * 2)) / 6
        
        let myStateLabel = ResultTitleLabel(frame: CGRectMake(margin , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myStateLabel.textAlignment = NSTextAlignment.Center
        myStateLabel.text = "Result"
        self.addSubview(myStateLabel)
        
        let myScoreCorrectSequenceLabel = ResultTitleLabel(frame: CGRectMake(myStateLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        myScoreCorrectSequenceLabel.text = "Correct\nsequence"
        myScoreCorrectSequenceLabel.numberOfLines = 2
        self.addSubview(myScoreCorrectSequenceLabel)
        
        let myScorePointsLabel = ResultTitleLabel(frame: CGRectMake(myScoreCorrectSequenceLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        myScorePointsLabel.textAlignment = NSTextAlignment.Center
        myScorePointsLabel.text = "Points"
        self.addSubview(myScorePointsLabel)
        
        
        
        let opponentNameLabel = ResultTitleLabel(frame: CGRectMake(myScorePointsLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentNameLabel.textAlignment = NSTextAlignment.Center
        opponentNameLabel.text = "Name"
        self.addSubview(opponentNameLabel)
        
        let opponentScoreCorrectSequenceLabel = ResultTitleLabel(frame: CGRectMake(opponentNameLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        opponentScoreCorrectSequenceLabel.text = "Correct\nsequence"
        opponentScoreCorrectSequenceLabel.numberOfLines = 2
        self.addSubview(opponentScoreCorrectSequenceLabel)
        
        let opponentScorePointsLabel = ResultTitleLabel(frame: CGRectMake(opponentScoreCorrectSequenceLabel.frame.maxX , myScoreLabel.frame.maxY, secondLevelTitleWidth, titleElementHeight))
        opponentScorePointsLabel.textAlignment = NSTextAlignment.Center
        opponentScorePointsLabel.text = "Points"
        self.addSubview(opponentScorePointsLabel)
        
        
        
        
        totalResultLabel = UILabel(frame: CGRectMake(margin ,self.bounds.height - titleElementHeight , self.bounds.width, titleElementHeight))
        totalResultLabel.textAlignment = NSTextAlignment.Left
        
        totalResultLabel.text = "    Victories 0 Losses 0 😐"
        //totalResultLabel.layer.borderColor = UIColor.whiteColor().CGColor
        //totalResultLabel.layer.borderWidth = 2.0
        totalResultLabel.adjustsFontSizeToFitWidth = true
        totalResultLabel.backgroundColor = UIColor.blueColor()
        totalResultLabel.textColor = UIColor.whiteColor()
        self.addSubview(totalResultLabel)
        
        
        
        
        scrollView = UIScrollView(frame: CGRectMake(0, opponentScorePointsLabel.frame.maxY, self.bounds.width, self.bounds.height - opponentScorePointsLabel.frame.maxY - totalResultLabel.frame.height))
        
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.blueColor().CGColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.borderWidth = 5.0
        

        items = []
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, 0)
        
        self.addSubview(scrollView)
        
    }
    
    
    func addItem(myCS:Int,myPoints:Int,opponentName:String,opponentCS:Int,opponentPoints:Int)
    {
        let itemheight:CGFloat = 40
        var contentHeight:CGFloat = 0
        
        let newItem = ResultItemView(frame: CGRectMake(0, 0, self.frame.width, itemheight), myCS: myCS,myPoints:myPoints,opponentName:opponentName,opponentCS:opponentCS,opponentPoints:opponentPoints)
        items.insert(newItem, atIndex: 0)
        scrollView.addSubview(newItem)
        
        contentHeight = newItem.frame.maxY
        var i:CGFloat = 0
        for item in items
        {
            item.frame = CGRectMake(0, itemheight * i, self.frame.width, itemheight)
            contentHeight = item.frame.maxY
            i++
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, contentHeight)
        
        
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