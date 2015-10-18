//
//  File.swift
//  PlaceInTime
//
//  Created by knut on 14/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation

class Challenge {

    var id:String!
    var fbIdToBeat:String!
    //var questions:[[HistoricEvent]]!
    var questionIds:[Int] = []
    var pointsToBeat:Int
    var correctAnswersToBeat:Int
    var title:String
    let datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
    
    init(values:NSDictionary)
    {
        title = values["title"] as! String
        id = values["challengeId"] as! String
        fbIdToBeat = values["fbIdToBeat"] as! String
        pointsToBeat = values["pointsToBeat"] as! Int
        correctAnswersToBeat = values["correctAnswersToBeat"] as! Int
        let questionsStringFormat = values["questionsStringFormat"] as! String
        
        let questionIdsStringFormat = questionsStringFormat.componentsSeparatedByString(",")
        for item in questionIdsStringFormat
        {
            let idAsNumber = NSNumberFormatter().numberFromString(item)
            questionIds.append(idAsNumber!.integerValue)
        }
    }
    
    func getNextQuestionId() -> Int?
    {
        return questionIds.count == 0 ? nil : questionIds.removeLast()
    }

}


