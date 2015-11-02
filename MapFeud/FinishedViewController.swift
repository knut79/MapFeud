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

    var userFbId:String!
    var gametype:GameType!
    var challenge:Challenge!
    var distance:Int!
    
    var client: MSClient?
    
    var activityLabel:UILabel!
    var backToMenuButton:UIButton!
    var resultLabel:UILabel!
    var audioPlayer = AVAudioPlayer()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.client = (UIApplication.sharedApplication().delegate as! AppDelegate).client
        

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
        
        
        if gametype == GameType.makingChallenge
        {
            if let makingChallenge = challenge as? MakingChallenge
            {
                finishMakingChallenge()
                activityLabel.text = "Sending challenge\n\(makingChallenge.title)..."
            }
        }
        else if gametype == GameType.takingChallenge
        {
            if let takingChallenge = challenge as? TakingChallenge
            {
                activityLabel.text = "Sending result of\n\(takingChallenge.title)"
                finishTakingChallenge(takingChallenge)
                
                let resultChallengeLabel = UILabel(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - 200, 25, 400, 50))
                resultChallengeLabel.textAlignment = NSTextAlignment.Center
                resultChallengeLabel.text = "Result of challenge \(takingChallenge.title)"
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
                
                if distance > takingChallenge.distanceToBeat
                {
                    youWonChallenge(takingChallenge)
                }
                else if distance == takingChallenge.distanceToBeat
                {
                    youDrewChallenge(takingChallenge)
                }
                else
                {
                    youLostChallenge(takingChallenge)
                }
            }
        }
        else
        {
            print("invalid GameType")
        }
        
        self.view.addSubview(self.backToMenuButton)
    }
    
    func youLostChallenge(takingChallenge:TakingChallenge)
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
            "\(distance) km" +
            "\n\nagainst" +
            "\n\n\(takingChallenge.distanceToBeat) km"
    }
    
    func youWonChallenge(takingChallenge:TakingChallenge)
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
        "\(distance) km" +
        "\n\nagainst" +
        "\n\n\(takingChallenge.distanceToBeat) km"
    }
    
    func youDrewChallenge(takingChallenge:TakingChallenge)
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
        resultLabel.text = "Challenge ended as draw 😐\n\n" +
            "\(distance) km" +
            "\n\nagainst" +
        "\n\n\(takingChallenge.distanceToBeat) km"
    }

    
    func finishMakingChallenge()
    {
        let makingChallenge = challenge as! MakingChallenge
        let challengeIds = makingChallenge.challengeIds

        let jsonDictionary = ["chidspar":challengeIds!,"fromId":userFbId,"fromResultDistance":distance]
        self.client!.invokeAPI("finishmakingchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as! [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
            if error != nil
            {
                self.backToMenuButton.alpha = 1
                self.activityLabel.text = "\(error)"
            }
            if result != nil
            {

                print("\(result)")
                
                self.backToMenuButton.alpha = 1
                
                let numUsersChallenged = makingChallenge.usersToChallenge.count
                
                self.activityLabel.text = numUsersChallenged > 1 ? "Challenge sendt to \(numUsersChallenged) users" : "Challenge sendt to \(numUsersChallenged) user"
            }
            if response != nil
            {
                print("\(response)")
            }
        })
    }
    
    func finishTakingChallenge(takingChallenge:TakingChallenge)
    {
        let jsonDictionary = ["userfbid":userFbId,"challengeid":takingChallenge.id,"resultdistance":distance]
        self.client!.invokeAPI("finishtakingchallenge", data: nil, HTTPMethod: "POST", parameters: jsonDictionary as! [NSObject : AnyObject], headers: nil, completion: {(result:NSData!, response: NSHTTPURLResponse!,error: NSError!) -> Void in
            
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
    
    func backToMenuAction()
    {
        self.performSegueWithIdentifier("segueFromFinishedToMainMenu", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        if (segue.identifier == "segueFromFinishedToMainMenu") {
            let svc = segue!.destinationViewController as! MainMenuViewController

            svc.updateGlobalGameStats = true
            svc.newGameStatsValues = (distance,0)
        }

    }
}