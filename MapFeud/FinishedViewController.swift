//
//  FinishedViewController.swift
//  PlaceInTime
//
//  Created by knut on 08/09/15.
//  Copyright (c) 2015 knut. All rights reserved.
//
import AVFoundation
import Foundation
import UIKit

class FinishedViewController:UIViewController {
    
    var usersIdsToChallenge:[String] = []
    var completedQuestionsIds:[String] = []
    var challengeName:String!
    
    var userFbId:String!
    var correctAnswers:Int!
    var points:Int!
    var gametype:gameType!
    var challengeToBeat:Challenge!
    var client: MSClient?
    
    var activityLabel:UILabel!
    var backToMenuButton:UIButton!
    var resultLabel:UILabel!
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
        
        /*
        self.client = MSClient(
            applicationURLString:"https://placeintime.azure-mobile.net/",
            applicationKey:"EPexqUWpxpiDBffWuGuiNUgjgTzeMz22"
        )
        */
        let margin:CGFloat = 20
        let elementWidth:CGFloat = 200
        let elementHeight:CGFloat = 40
        backToMenuButton = UIButton(frame:CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (elementWidth / 2), UIScreen.mainScreen().bounds.size.height - margin - elementHeight, elementWidth , elementHeight))
        backToMenuButton.addTarget(self, action: "backToMenuAction", forControlEvents: UIControlEvents.TouchUpInside)
        backToMenuButton.backgroundColor = UIColor.blueColor()
        backToMenuButton.layer.cornerRadius = 5
        backToMenuButton.layer.masksToBounds = true
        backToMenuButton.setTitle("Back to menu", forState: UIControlState.Normal)
        backToMenuButton.alpha = 0
        
        
        activityLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width - 40, 100))
        activityLabel.center = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        activityLabel.adjustsFontSizeToFitWidth = true
        activityLabel.textAlignment = NSTextAlignment.Center
        activityLabel.font = UIFont.boldSystemFontOfSize(24)
        activityLabel.numberOfLines = 2
        
        self.view.addSubview(activityLabel)
        
        
        if gametype == gameType.makingChallenge
        {
            newChallenge()
            activityLabel.text = "Sending challenge\n\(challengeName)..."
        }
        
        if gametype == gameType.takingChallenge
        {
            
            activityLabel.text = "Sending result of\n\(challengeName)"
            respondToChallenge()
            
            let resultChallengeLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - 200, 25, 400, 50))
            resultChallengeLabel.textAlignment = NSTextAlignment.Center
            resultChallengeLabel.text = "Result of challenge \(self.challengeToBeat.title)"
            resultChallengeLabel.font = UIFont.boldSystemFontOfSize(20)
            resultChallengeLabel.adjustsFontSizeToFitWidth = true
            self.view.addSubview(resultChallengeLabel)
            
            resultLabel = UILabel(frame: CGRectMake(margin, resultChallengeLabel.frame.maxY , UIScreen.mainScreen().bounds.size.width - (margin * 2),  backToMenuButton.frame.minY - resultChallengeLabel.frame.maxY))
            resultLabel.numberOfLines = 9
            resultLabel.backgroundColor = UIColor.grayColor()
            resultLabel.textAlignment = NSTextAlignment.Center
            resultLabel.textColor = UIColor.blackColor()
            resultLabel.adjustsFontSizeToFitWidth = true
            resultLabel.backgroundColor = UIColor.whiteColor()
            resultLabel.layer.borderColor = UIColor.blueColor().CGColor
            resultLabel.layer.cornerRadius = 8
            resultLabel.layer.masksToBounds = true
            resultLabel.layer.borderWidth = 5.0
            self.view.addSubview(resultLabel)
            


            
            //sending result
            
            if correctAnswers > challengeToBeat.correctAnswersToBeat
            {
                youWonChallenge()
            }
            else if correctAnswers == challengeToBeat.correctAnswersToBeat && points > challengeToBeat.pointsToBeat
            {
                youWonChallenge()
            }
            else
            {
                youLostChallenge()
            }
        }
        self.view.addSubview(self.backToMenuButton)
    }
    
    func youLostChallenge()
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("lostChallenge", ofType: "mp3")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch let error1 as NSError {
            print(error1)
            
        }
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        resultLabel.text = "You lost 😖\n\n" +
            "\(correctAnswers) correct answers" + "\n\(points) points" +
            "\n\nagainst" +
            "\n\n\(challengeToBeat.correctAnswersToBeat) correct answers" + "\n\(challengeToBeat.pointsToBeat) points"
    }
    
    func youWonChallenge()
    {
        let sound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("fanfare2", ofType: "wav")!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: sound)
        } catch let error1 as NSError {
            print(error1)
        }
        audioPlayer.numberOfLoops = 0
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        resultLabel.text = "You won 😆\n\n" +
        "\(correctAnswers) correct answers" + "\n\(points) points" +
        "\n\nagainst" +
        "\n\n\(challengeToBeat.correctAnswersToBeat) correct answers" + "\n\(challengeToBeat.pointsToBeat) points"
    }

    
    func newChallenge()
    {
        
        let questionIds:String = questionsToCommaseparatedString()
        //var jsonDictionary = ["title":"heihei","fromId":"123","fromResultPoints":"333","fromResultCorrect":"3","toIds":toIdsArray,"questions":questionsArray]
        let toIds:String = usersToCommaseparatedString()
        //var dataPass = .dataWithJSONObject(toIdsArray, options: NSJSONWritingOptions.allZeros, error: nil)
        //var dataTest = NSJSONSerialization.dataWithJSONObject(
        let jsonDictionary = ["title":challengeName,"fromId":userFbId,"fromResultPoints":points,"fromResultCorrect":correctAnswers,"toIdsPar":toIds,"questionsPar":questionIds]
        self.client!.invokeAPI("challenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as! [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                self.backToMenuButton.alpha = 1
                self.activityLabel.text = "\(error)"
            }
            if result != nil
            {
                print("\(result)")
                
                self.backToMenuButton.alpha = 1
                //self.activityLabel.alpha = 0
                
                self.activityLabel.text = self.usersIdsToChallenge.count > 1 ? "Challenge sendt to \(self.usersIdsToChallenge.count) users" : "Challenge sendt to \(self.usersIdsToChallenge.count) user"
            }
            if response != nil
            {
                print("\(response)")
            }
        })
    }
    
    func respondToChallenge()
    {
        let jsonDictionary = ["userfbid":userFbId,"challengeid":challengeToBeat.id,"resultpoints":points,"resultcorrect":correctAnswers]
        self.client!.invokeAPI("finishchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as! [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                self.backToMenuButton.alpha = 1
                self.activityLabel.text = "\(error)"
            }
            if result != nil
            {
                print("\(result)")
                
                self.backToMenuButton.alpha = 1
                self.activityLabel.alpha = 0
            }
            if response != nil
            {
                print("\(response)")
            }
            
            
        })
    }
    
    func usersToCommaseparatedString() -> String
    {
        var returnString:String = ""
        for item in usersIdsToChallenge
        {
            returnString += item + ","
            
        }
        return String(returnString.characters.dropLast())
    }
    
    func questionsToCommaseparatedString() -> String
    {
        var returnString:String = ""
        for questionId in completedQuestionsIds
        {
            returnString += questionId + ","
        }
        return String(returnString.characters.dropLast())
        
    }
    
    func backToMenuAction()
    {
        self.performSegueWithIdentifier("segueFromFinishedToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromFinishedToMainMenu") {
            let svc = segue!.destinationViewController as! MainMenuViewController

            svc.updateGlobalGameStats = true
            svc.newGameStatsValues = (points,0,correctAnswers)
        }

    }
    
    /*
    func sendChallenge()
    {
        let url = NSURL(string: "http://myrestservice")
        let theRequest = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(theRequest, queue: nil, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if data.length > 0 && error == nil {
                let response : AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.fromMask(0), error: nil)
            }
        })
    }
    */
    
    /*
    - (void) sendChallenge:(NSDictionary*) jsonDictionary completion:(MSAPIDataBlock)completion
    {
    //NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys: @"1", @"level", nil];
    [self.client
    invokeAPI:@"dynamicchallenge"
    data:nil
    HTTPMethod:@"POST"
    parameters:jsonDictionary
    headers:nil
    completion:completion ];
    }
    */
}