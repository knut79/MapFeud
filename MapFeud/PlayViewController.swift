//
//  ViewController.swift
//  MapFeud
//
//  Created by knut on 05/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController , MapDelegate {

    var datactrl:DataHandler!
    var map:MapScrollView!
    var playerIcon:PlayerIconView!
    var magnifyingGlass: MagnifyingGlassView!
    var magnifyingGlassLeftPos:CGPoint!
    var magnifyingGlassRightPos:CGPoint!
    var questionView:QuestionView!
    var answerView:AnswerView!
    var currentQuestion:Question!
    
    var distanceView:DistanceView!
    
    var levelHigh:Int = 1
    var levelLow:Int = 1
    var tags:[String] = []
    var gametype:gameType!
    var usersIdsToChallenge:[String] = []
    var completedQuestionsIds:[String] = []
    var numOfQuestionsForRound:Int!
    var myIdAndName:(String,String)!
    
    var challenge:Challenge!
    
    var hintButton:HintButton!
    var okButton:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map = MapScrollView(frame: UIScreen.mainScreen().bounds)
        map.delegate = self
        
        playerIcon = PlayerIconView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 0.12, UIScreen.mainScreen().bounds.width * 0.12))
        playerIcon.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        playerIcon.userInteractionEnabled = true
        map.addSubview(playerIcon)
        
        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl

        
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapMap:")
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.enabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        map.addGestureRecognizer(singleTapGestureRecognizer)
        
        self.view.addSubview(map)
        
        let questonViewHeight = UIScreen.mainScreen().bounds.height * 0.1
        
        let magnifyingSide = UIScreen.mainScreen().bounds.width * 0.22
        magnifyingGlass = MagnifyingGlassView(frame: CGRectMake( 0 , 0 ,magnifyingSide , magnifyingSide))
        magnifyingGlassLeftPos = CGPointMake((magnifyingSide / 2) ,questonViewHeight + (magnifyingSide / 2))
        magnifyingGlassRightPos = CGPointMake(UIScreen.mainScreen().bounds.width - (magnifyingSide / 2) , questonViewHeight + (magnifyingSide / 2))
        magnifyingGlass.center = magnifyingGlassLeftPos
        magnifyingGlass.mapToMagnify = map
        magnifyingGlass.alpha = 0
        self.view.addSubview(magnifyingGlass)
        
        distanceView = DistanceView(frame: CGRectMake(0, map.bounds.maxY - questonViewHeight, UIScreen.mainScreen().bounds.width, questonViewHeight))
        distanceView.alpha = 1
        self.view.addSubview(distanceView)
        
        setupButtons()
        
        questionView = QuestionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, questonViewHeight))
        questionView.alpha = 0
        self.view.addSubview(questionView)
        
        answerView = AnswerView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, questonViewHeight))
        answerView.alpha = 0
        self.view.addSubview(answerView)
        

        
        datactrl.fetchData()
        datactrl.shuffleQuestions()
        datactrl.orderOnUsed()
        
        
        startGame()


    }
    
    func setupButtons()
    {
        let margin = UIScreen.mainScreen().bounds.width * 0.025
        
        let buttonSide = UIScreen.mainScreen().bounds.width * 0.15
        
        hintButton = HintButton(frame: CGRectMake(0, 0, buttonSide, buttonSide))
        hintButton.center = CGPointMake(margin + (hintButton.frame.width / 2) , UIScreen.mainScreen().bounds.height * 0.33)
        hintButton.addTarget(self, action: "useHintAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(hintButton)

        
        okButton = UIButton(frame: CGRectMake(0, 0, buttonSide, buttonSide))
        okButton.center = CGPointMake(UIScreen.mainScreen().bounds.width - (okButton.frame.width / 2) - margin , UIScreen.mainScreen().bounds.height - (okButton.frame.height / 2) - margin)
        okButton.addTarget(self, action: "okAction", forControlEvents: UIControlEvents.TouchUpInside)
        okButton.setTitle("🆗", forState: UIControlState.Normal)
        okButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        okButton.layer.borderWidth = 2
        okButton.layer.cornerRadius = okButton.bounds.size.width / 2
        okButton.layer.masksToBounds = true
        self.view.addSubview(okButton)
    }

    
    func useHintAction()
    {

    }
    
    func okAction()
    {
        setPoint()
    }
    
    func setPoint()
    {
        playerIcon.alpha = 0
        map.setPoint(playerIcon.center)
        //let southAfricaTestExcluded = datactrl.fetchPlace("South Africa")
        //let southAfricaTestExcluded = datactrl.fetchPlace("Usa")
        //let southAfricaTestExcluded = datactrl.fetchPlace("Japan")
        let southAfricaTestExcluded = currentQuestion.place

        map.animateAnswer(southAfricaTestExcluded)
    }
    
    func finishedAnimatingAnswer(distance:Int)
    {
        if let qv = answerView
        {
            qv.setAnswer(currentQuestion, distance: distance)
        }
        showAnswer({() -> Void in
            self.animateDistanceToAdd(distance)
        })

    }
    
    func animateDistanceToAdd(distance:Int)
    {
        let tempIconAnimateLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width / 2, 50))
        tempIconAnimateLabel.center = CGPointMake( UIScreen.mainScreen().bounds.midX, UIScreen.mainScreen().bounds.midY)
        tempIconAnimateLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(tempIconAnimateLabel)
        
        let tempDisctanceAnimateLabel = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width / 2, 50))
        tempDisctanceAnimateLabel.textColor = UIColor.whiteColor()
        tempDisctanceAnimateLabel.center = CGPointMake( UIScreen.mainScreen().bounds.midX, UIScreen.mainScreen().bounds.midY)
        tempDisctanceAnimateLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(tempDisctanceAnimateLabel)

        tempDisctanceAnimateLabel.center = CGPointMake( UIScreen.mainScreen().bounds.midX, UIScreen.mainScreen().bounds.midY)
        tempDisctanceAnimateLabel.alpha = 0
        tempDisctanceAnimateLabel.text = "\(distance) km"
        
        tempIconAnimateLabel.text = getEmojiOnMissedDistance(distance)
        tempIconAnimateLabel.alpha = 0
        tempIconAnimateLabel.transform = CGAffineTransformScale(tempIconAnimateLabel.transform, 0.1, 0.1)
        UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            tempIconAnimateLabel.alpha = 1
            tempIconAnimateLabel.transform = CGAffineTransformIdentity
            tempIconAnimateLabel.transform = CGAffineTransformScale(tempIconAnimateLabel.transform, 2, 2)
            tempIconAnimateLabel.frame.offsetInPlace(dx: 0, dy: UIScreen.mainScreen().bounds.height * 0.1)
            tempDisctanceAnimateLabel.alpha = 1
            }, completion: { (value: Bool) in
                
                UIView.animateWithDuration(1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    tempIconAnimateLabel.transform = CGAffineTransformIdentity
                    tempIconAnimateLabel.transform = CGAffineTransformScale(tempIconAnimateLabel.transform, 0.5, 0.5)
                    tempIconAnimateLabel.alpha = 0

                    
                    tempDisctanceAnimateLabel.center = self.distanceView.center
                    
                    }, completion: { (value: Bool) in
                        tempDisctanceAnimateLabel.removeFromSuperview()
                        tempIconAnimateLabel.removeFromSuperview()
                        self.distanceView.addDistance(distance)
                })

        })
    }
    
    func getEmojiOnMissedDistance(missedDistance:Int) -> String
    {
        var emoji = "😀"
        if(missedDistance > 2000){
            emoji = "😭"
        }
        else if(missedDistance > 1200){
            emoji = "😫"
        }
        else if(missedDistance > 600){
            emoji = "😬"
        }
        else if(missedDistance > 250){
            emoji = "😐"
        }
        else if(missedDistance > 0){
            emoji = "😌"
        }
        return emoji

    }
    
    func showAnswer(completion: (() -> (Void)))
    {
        
        answerView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        self.answerView.answerText.textColor = UIColor.whiteColor()
        self.answerView.userInteractionEnabled = true
        
        self.answerView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        self.answerView.transform = CGAffineTransformScale(self.answerView.transform, 0.1, 0.1)
        UIView.animateWithDuration(0.50, animations: { () -> Void in
            self.questionView.alpha = 0
            self.answerView.alpha = 1
            self.answerView.transform = CGAffineTransformIdentity
            }, completion: { (value: Bool) in
                
                UIView.animateWithDuration(1, animations: { () -> Void in
                    
                    self.answerView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, self.questionView.frame.height / 2)
                    self.answerView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
                    
                    
                    }, completion: { (value: Bool) in
                        
                        self.answerView.answerText.textColor = UIColor.blackColor()
                        completion()
                        //self.setNextQuestion()
                        //self.playerIcon.alpha = 1
                        
                })
            })
    }
    
    
    var questionindex = 0
    func startGame()
    {
        setNextQuestion()
    }
    
    func setNextQuestion()
    {
        self.answerView.userInteractionEnabled = false
        currentQuestion = datactrl.questionItems[questionindex % datactrl.questionItems.count]
        questionindex++
        if let qv = questionView
        {
            qv.setQuestion(currentQuestion)
        }
        
        
        showQuestion()
    }
    
    func showQuestion()
    {
        questionView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, UIScreen.mainScreen().bounds.height / 2)
        self.questionView.questionText.textColor = UIColor.whiteColor()
        
        
        self.questionView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)
        self.questionView.transform = CGAffineTransformScale(self.questionView.transform, 0.1, 0.1)
        UIView.animateWithDuration(0.50, animations: { () -> Void in
            
            self.questionView.alpha = 1
            self.questionView.transform = CGAffineTransformIdentity
            }, completion: { (value: Bool) in
                
                UIView.animateWithDuration(1, animations: { () -> Void in
                    
                    self.questionView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, self.questionView.frame.height / 2)
                    self.questionView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
                    
                    
                    }, completion: { (value: Bool) in
                        
                        self.questionView.questionText.textColor = UIColor.blackColor()
                        
                })
                
        })
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.locationInView(self.view)
        
        let isInnView = CGRectContainsPoint(playerIcon!.frame,touchLocation)
        if(isInnView)
        {
            magnifyingGlass.center = touchLocation
            playerIcon.center = touchLocation
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.magnifyingGlass.alpha = 1
                    self.magnifyingGlass.center = self.magnifyingGlassRightPos
                    self.magnifyingGlass.transform = CGAffineTransformIdentity
                    self.playerIcon.transform = CGAffineTransformScale(self.playerIcon.transform, 1.3, 1.3)
                }, completion: { (value: Bool) in
            })
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let touch = touches.first //touches.anyObject()
        let touchLocation = touch!.locationInView(self.view)
        let isInnView = CGRectContainsPoint(playerIcon.frame,touchLocation)
        let isInnMagnifyingView = CGRectContainsPoint(magnifyingGlass.frame,touchLocation)
        
        if(isInnMagnifyingView)
        {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                if self.magnifyingGlass.center == self.magnifyingGlassLeftPos
                {
                    self.magnifyingGlass.center = self.magnifyingGlassRightPos
                }
                else
                {
                    self.magnifyingGlass.center = self.magnifyingGlassLeftPos
                }
                })

        }
        else if(isInnView)
        {
            playerIcon.alpha = 0
            magnifyingGlass.setTouchPoint(touchLocation)
            magnifyingGlass.setNeedsDisplay()
            
            let point = touches.first!.locationInView(self.view) //touches.anyObject()!.locationInView(self.view)
            //playerIcon.center = CGPointMake(point.x - xOffset, point.y - yOffset)
            playerIcon.center = CGPointMake(point.x , point.y)
        }
        else
        {

            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.playerIcon.alpha = 1
                self.magnifyingGlass.alpha = 0
                self.magnifyingGlass.center = touchLocation
                self.magnifyingGlass.transform = CGAffineTransformScale(self.magnifyingGlass.transform, 0.1, 0.1)
                self.playerIcon.transform = CGAffineTransformIdentity
                }, completion: { (value: Bool) in
            })
        }

    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first//touches.anyObject()
        let touchLocation = touch!.locationInView(self.view)
        playerIcon.alpha = 1
        let isInnView = CGRectContainsPoint(self.playerIcon!.frame,touchLocation)
        if(isInnView)
        {
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.magnifyingGlass.alpha = 0
                self.magnifyingGlass.center = touchLocation
                self.magnifyingGlass.transform = CGAffineTransformScale(self.magnifyingGlass.transform, 0.1, 0.1)
                self.playerIcon.transform = CGAffineTransformIdentity
                }, completion: { (value: Bool) in
            })
        }
    }
    
    func tapMap(gesture:UITapGestureRecognizer)
    {
        let touchLocation = gesture.locationInView(self.map)
        playerIcon.center = touchLocation
        
        self.playerIcon.transform = CGAffineTransformScale(self.playerIcon.transform, 1.3, 1.3)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.playerIcon.transform = CGAffineTransformIdentity
            }, completion: { (value: Bool) in
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

