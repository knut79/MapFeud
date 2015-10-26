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
    
    init(frame: CGRect,myDistance:Int,opponentName:String,opponentDistance:Int) {
        super.init(frame: frame)
        
        let margin:CGFloat = 0
        let secondLevelTitleWidth:CGFloat = (self.bounds.width - ( margin * 2)) / 4
        let titleElementHeight:CGFloat = 40
        
        var state = "Victory"
        stateWin = 1
        if opponentDistance < myDistance
        {
            stateWin = 0
            stateLoss = 1
            state = "Loss"
        }
        else if myDistance == opponentDistance
        {
            stateWin = 0
            state = "Draw"
        }
        
        let myStateLabel = UILabel(frame: CGRectMake(margin , 0, secondLevelTitleWidth, titleElementHeight))
        myStateLabel.textAlignment = NSTextAlignment.Center
        myStateLabel.text = "\(state)"
        myStateLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myStateLabel)
        
        
        let myDistancePointsLabel = UILabel(frame: CGRectMake(myStateLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        myDistancePointsLabel.textAlignment = NSTextAlignment.Center
        myDistancePointsLabel.text = "\(myDistance)"
        myDistancePointsLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(myDistancePointsLabel)
        
        
        
        let opponentNameLabel = UILabel(frame: CGRectMake(myDistancePointsLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentNameLabel.textAlignment = NSTextAlignment.Center
        opponentNameLabel.text = "\(opponentName)"
        opponentNameLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentNameLabel)
        

        
        let opponentDistanceLabel = UILabel(frame: CGRectMake(opponentNameLabel.frame.maxX , 0, secondLevelTitleWidth, titleElementHeight))
        opponentDistanceLabel.textAlignment = NSTextAlignment.Center
        opponentDistanceLabel.text = "\(opponentDistance)"
        opponentDistanceLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(opponentDistanceLabel)
    }
}