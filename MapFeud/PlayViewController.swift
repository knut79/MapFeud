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
    var okButton:OkButton!
    var nextButton:UIButton!
    var nextButtonVisibleOrigin:CGPoint!
    var nextButtonHiddenOrigin:CGPoint!
    
    var backButton:UIButton?
    var backButtonOrgFrame:CGRect?
    var backButtonVisibleOrigin:CGPoint!
    var backButtonHiddenOrigin:CGPoint!
    
    var drawBorders:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map = MapScrollView(frame: UIScreen.mainScreen().bounds, drawBorders: drawBorders)
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
        
        distanceView = DistanceView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width * 0.66, questonViewHeight))
        distanceView.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2, map.bounds.maxY - (questonViewHeight / 2))
        distanceView.alpha = 1
        self.view.addSubview(distanceView)
        distanceView.orgFrame = distanceView.frame
        
        setupButtons()
        
        questionView = QuestionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, questonViewHeight))
        questionView.alpha = 0
        self.view.addSubview(questionView)
        questionView.orgFrame = questionView.frame
        
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
        hintButton.orgFrame = hintButton.frame

        
        okButton = OkButton(frame: CGRectMake(0, 0, buttonSide, buttonSide))
        okButton.center = CGPointMake(UIScreen.mainScreen().bounds.width - (okButton.frame.width / 2) - margin , UIScreen.mainScreen().bounds.height - (okButton.frame.height / 2) - margin)
        okButton.addTarget(self, action: "okAction", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(okButton)
        okButton.orgFrame = okButton.frame
            
        nextButton = UIButton(frame: okButton.orgFrame)
        nextButton.addTarget(self, action: "nextAction", forControlEvents: UIControlEvents.TouchUpInside)
        nextButton.setTitle("⏩", forState: UIControlState.Normal)
        nextButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        nextButton.layer.borderWidth = 2
        nextButton.layer.cornerRadius = nextButton.bounds.size.width / 2
        nextButton.layer.masksToBounds = true
        self.view.addSubview(nextButton)
        nextButtonVisibleOrigin = nextButton.center
        //initially hide next button
        nextButtonHiddenOrigin = CGPointMake(UIScreen.mainScreen().bounds.maxX + nextButton.frame.width, nextButton.center.y)
        nextButton.center = nextButtonHiddenOrigin
        
        if gametype == gameType.training
        {
            backButton = UIButton(frame: CGRectMake(margin, UIScreen.mainScreen().bounds.maxY - buttonSide - margin, buttonSide, buttonSide))
            backButton!.addTarget(self, action: "backAction", forControlEvents: UIControlEvents.TouchUpInside)
            backButton!.setTitle("⏪", forState: UIControlState.Normal)
            backButton!.layer.borderColor = UIColor.lightGrayColor().CGColor
            backButton!.layer.borderWidth = 2
            backButton!.layer.cornerRadius = backButton!.bounds.size.width / 2
            backButton!.layer.masksToBounds = true
            self.view.addSubview(backButton!)
            backButtonVisibleOrigin = backButton!.center
            //initially hide next button
            backButtonHiddenOrigin = CGPointMake(backButton!.frame.width * -1 , backButton!.center.y)
            //backButton!.center = backButtonHiddenOrigin
            backButtonOrgFrame = backButton!.frame
        }

    }

    func useHintAction()
    {
        var hintText:String?
        if self.hintButton.hintsLeftOnQuestion >= 2
        {
            hintText = currentQuestion.place.hint1
        }
        else if self.hintButton.hintsLeftOnQuestion >= 1
        {
            hintText = currentQuestion.place.hint2
        }
        else if self.hintButton.hintsLeftOnAccount == 0
        {
             hintText = "Buy more hints"
        }

        if let text = hintText
        {
            self.hintButton.deductHints()
            let numberPrompt = UIAlertController(title: "Hint",
                message: text,
                preferredStyle: .Alert)
            
            
            numberPrompt.addAction(UIAlertAction(title: "Ok",
                style: .Default,
                handler: { (action) -> Void in
                    
            }))
            
            
            self.presentViewController(numberPrompt,
                animated: true,
                completion: nil)
        }
    }
    
    func backAction()
    {
        self.performSegueWithIdentifier("segueFromPlayToMainMenu", sender: nil)
    }
    
    func okAction()
    {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            //self.hideHintButton()
            self.hintButton.hide()
            self.okButton.hide()
            }, completion: { (value: Bool) in
                self.setPoint()
                
        })
        
    }
    
    func setPoint()
    {
        playerIcon.alpha = 0
        map.setPoint(playerIcon.center)
        let questionPlace = currentQuestion.place

        map.animateAnswer(questionPlace)
    }
    
    func finishedAnimatingAnswer(distance:Int)
    {
        if let qv = answerView
        {
            qv.setAnswer(currentQuestion, distance: distance)
        }
        showAnswer({() -> Void in
            self.animateDistanceToAdd(distance,completion: {() -> Void in
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.hideNextButton(false)
                    self.hintButton.hide()
                    self.playerIcon.alpha = 0
                    })
                

            })
        })

    }
    
    func animateDistanceToAdd(distance:Int,completion: (() -> (Void)))
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
                        
                        completion()
                        
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

                        
                })
            })
    }
    
    func nextAction()
    {

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            //self.hideHintButton(false)
            self.hintButton.hide(false)
            self.okButton.hide(false)
            self.hideNextButton()
            }, completion: { (value: Bool) in
                self.setNextQuestion()
                self.playerIcon.alpha = 1
        })

        
    }
    
    var questionindex = 0
    func startGame()
    {
        setNextQuestion()
    }
    
    func setNextQuestion()
    {
        self.hintButton.restoreHints()
        map.clearDrawing()
        self.answerView.userInteractionEnabled = false
        currentQuestion = datactrl.questionItems[questionindex % datactrl.questionItems.count]
        //currentQuestion = datactrl.fetchPlace("Japan")!.questions.allObjects[0] as! Question
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
            self.answerView.alpha = 0
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
        
        if(isInnView)
        {
            let isInnHintButtonView = CGRectContainsPoint(hintButton.orgFrame, touchLocation)
            let isInnOkButtonView = CGRectContainsPoint(okButton.orgFrame, touchLocation)
            let isInnMagnifyingView = CGRectContainsPoint(magnifyingGlass.frame,touchLocation)
            let isInnQuestionView = CGRectContainsPoint(questionView.orgFrame,touchLocation)
            let isInnDistanceView = CGRectContainsPoint(distanceView.orgFrame, touchLocation)
            let isInnBackButtonView = backButton != nil ? CGRectContainsPoint(self.backButtonOrgFrame!, touchLocation) : false
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
            else if isInnHintButtonView || isInnQuestionView || isInnOkButtonView || isInnDistanceView || isInnBackButtonView
            {
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    /*
                    if self.hintButton.frame == self.hintButtonOrgFrame && isInnHintButtonView
                    {
                        self.hideHintButton()
                    }
                    */
                    if self.hintButton.isVisible() && isInnHintButtonView
                    {
                        self.hintButton.hide()
                    }
                    if self.questionView.isVisible() && isInnQuestionView
                    {
                        self.questionView.hide()
                    }
                    if self.okButton.isVisible() && isInnOkButtonView
                    {
                        self.okButton.hide()
                    }
                    if let button = self.backButton
                    {
                        if isInnBackButtonView && button.frame == self.backButtonOrgFrame
                        {
                            self.hideBackButton()
                        }
                    }
                    if self.distanceView.isVisible() && isInnDistanceView
                    {
                        self.distanceView.hide()
                    }

                })
            }
            else
            {
                UIView.animateWithDuration(0.25, animations: { () -> Void in

                    if !self.hintButton.isVisible()
                    {
                        self.hintButton.hide(false)
                    }
                    if !self.questionView.isVisible()
                    {
                        self.questionView.hide(false)
                    }
                    if !self.okButton.isVisible()
                    {
                        self.okButton.hide(false)
                    }
                    if let button = self.backButton
                    {
                        if button.frame != self.backButtonOrgFrame
                        {
                            self.hideBackButton(false)
                        }
                    }
                    if !self.distanceView.isVisible()
                    {
                        self.distanceView.hide(false)
                    }
                })
            }
            
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

    
    func hideNextButton(hide:Bool = true)
    {
        if hide
        {
            self.nextButton.center = nextButtonHiddenOrigin
        }
        else
        {
            self.nextButton.center = nextButtonVisibleOrigin
        }
    }
    
    func hideBackButton(hide:Bool = true)
    {
        if hide
        {
            self.backButton?.center = self.backButtonHiddenOrigin
        }
        else
        {
            self.backButton?.center = self.backButtonVisibleOrigin
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

