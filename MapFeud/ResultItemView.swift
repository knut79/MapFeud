//
//  ResultItemView.swift
//  PlaceInTime
//
//  Created by knut on 17/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class ResultItemView: UIView
{
    var title:String!
    var stateWin:Int = 0
    var stateLoss:Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, myCS:Int,myPoints:Int,opponentName:String,opponentCS:Int,opponentPoints:Int) {
        super.init(frame: frame)
        
        let margin:CGFloat = 0
        let secondLevelTitleWidth:CGFloat = (self.bounds.width - ( margin * 2)) / 6
        let titleElementHeight:CGFloat = 40
        
        var state = "Victory"
        stateWin = 1
        if myCS < opponentCS
        {
            stateWin = 0
            stateLoss = 1
            state = "Loss"
        }
        else if myCS == opponentCS && myPoints < opponentPoints
        {
            stateWin = 0
            stateLoss = 1
            state = "Loss"
        }
        else if myCS == opponentCS && myPoints == opponentPoints
        {
            stateWin = 0
            state = "Draw"
        }
        
        let myStateLabel = UILabel(frame: CGRectMake(margin , 0, secondLevelTitleWidth, titleElementHeight))
        myStateLabel.textAlignment = NSTextAlignment.Center
        myStateLabel.text = "\(state)"
        myStateLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myStateLabel)
        
        let myScoreCorrectSequenceLabel = UILabel(frame: CGRectMake(myStateLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        myScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        myScoreCorrectSequenceLabel.text = "\(myCS)"
        myScoreCorrectSequenceLabel.numberOfLines = 2
        myScoreCorrectSequenceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScoreCorrectSequenceLabel)
        
        let myScorePointsLabel = UILabel(frame: CGRectMake(myScoreCorrectSequenceLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        myScorePointsLabel.textAlignment = NSTextAlignment.Center
        myScorePointsLabel.text = "\(myPoints)"
        myScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myScorePointsLabel)
        
        
        
        let opponentNameLabel = UILabel(frame: CGRectMake(myScorePointsLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentNameLabel.textAlignment = NSTextAlignment.Center
        opponentNameLabel.text = "\(opponentName)"
        opponentNameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentNameLabel)
        
        let opponentScoreCorrectSequenceLabel = UILabel(frame: CGRectMake(opponentNameLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentScoreCorrectSequenceLabel.textAlignment = NSTextAlignment.Center
        opponentScoreCorrectSequenceLabel.text = "\(opponentCS)"
        opponentScoreCorrectSequenceLabel.numberOfLines = 2
        opponentScoreCorrectSequenceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentScoreCorrectSequenceLabel)
        
        let opponentScorePointsLabel = UILabel(frame: CGRectMake(opponentScoreCorrectSequenceLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentScorePointsLabel.textAlignment = NSTextAlignment.Center
        opponentScorePointsLabel.text = "\(opponentPoints)"
        opponentScorePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentScorePointsLabel)
    }
}