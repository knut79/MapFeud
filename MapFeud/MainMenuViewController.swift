    //
//  ViewController.swift
//  TimeIt
//
//  Created by knut on 12/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore
import iAd
import StoreKit

class MainMenuViewController: UIViewController, TagCheckViewProtocol , ADBannerViewDelegate, HolderViewDelegate,SKProductsRequestDelegate {


    //payment
    var product: SKProduct?
    var productID = "TimelineFeudAddFree1234"
    
    //buttons
    var challengeUsersButton:UIButton!
    var resultsButton:UIButton!
    var resultsChallengeButton:UIButton!
    var resultsTimelineButton:UIButton!
    var adFreeButton:UIButton!
    var dynamicPlayButton:UIButton!
    var newChallengeButton:UIButton!
    var pendingChallengesButton:UIButton!
    var practiceButton:UIButton!
    var selectFilterTypeButton:UIButton!
    var timelineButton:UIButton!
    
    var playButtonExstraLabel:UILabel!
    var playButtonExstraLabel2:UILabel!
    var borderSwitch:UISwitch!
    var borderSwitchLabel:UILabel!
    
    
    var loadingDataView:UIView!
    var loadingDataLabel:UILabel!
    var datactrl:DataHandler!
    var tagsScrollViewEnableBackground:UIView!
    var tagsScrollView:TagCheckScrollView!
    
    let queue = NSOperationQueue()
    
    var updateGlobalGameStats:Bool = false
    var newGameStatsValues:(Int,Int,Int)!

    let levelSlider = RangeSlider(frame: CGRectZero)
    var gametype:gameType!
    var tags:[String] = []
    
    var holderView:HolderView!
    
    var numOfQuestionsForRound:Int = 2
    
    var bannerView:ADBannerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")

        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl

        challengeUsersButton = UIButton(frame:CGRectZero)
        challengeUsersButton.addTarget(self, action: "challengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        challengeUsersButton.backgroundColor = UIColor.blueColor()
        challengeUsersButton.layer.cornerRadius = 5
        challengeUsersButton.layer.masksToBounds = true
        challengeUsersButton.setTitle("Challenge", forState: UIControlState.Normal)
        challengeUsersButton.alpha = 0
        
        practiceButton = UIButton(frame:CGRectZero)
        practiceButton.addTarget(self, action: "practiceAction", forControlEvents: UIControlEvents.TouchUpInside)
        practiceButton.backgroundColor = UIColor.blueColor()
        practiceButton.layer.cornerRadius = 5
        practiceButton.layer.masksToBounds = true
        practiceButton.setTitle("Practice", forState: UIControlState.Normal)
        practiceButton.alpha = 0
        
        resultsButton = UIButton(frame:CGRectZero)
        resultsButton.addTarget(self, action: "resultAction", forControlEvents: UIControlEvents.TouchUpInside)
        resultsButton.backgroundColor = UIColor.blueColor()
        resultsButton.layer.cornerRadius = 5
        resultsButton.layer.masksToBounds = true
        resultsButton.setTitle("Results", forState: UIControlState.Normal)
        resultsButton.alpha = 0
        
        adFreeButton = UIButton(frame:CGRectZero)
        adFreeButton.addTarget(self, action: "buyProductAction", forControlEvents: UIControlEvents.TouchUpInside)
        adFreeButton.backgroundColor = UIColor.grayColor()
        adFreeButton.userInteractionEnabled = false
        adFreeButton.layer.cornerRadius = 5
        adFreeButton.layer.masksToBounds = true
        adFreeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        adFreeButton.alpha = 0
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        if !adFree
        {
            adFreeButton.backgroundColor = UIColor.blueColor()
            adFreeButton.userInteractionEnabled = true
            adFreeButton.setTitle("Remove ads", forState: UIControlState.Normal)
            
            self.canDisplayBannerAds = true
            bannerView = ADBannerView(frame: CGRectZero)
            bannerView!.center = CGPoint(x: bannerView!.center.x, y: self.view.bounds.size.height - bannerView!.frame.size.height / 2)
            self.view.addSubview(bannerView!)
            self.bannerView?.delegate = self
            self.bannerView?.hidden = false
        }
        
        resultsChallengeButton = UIButton(frame:CGRectZero)
        resultsChallengeButton.addTarget(self, action: "resultChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        resultsChallengeButton.backgroundColor = UIColor.blueColor()
        resultsChallengeButton.layer.cornerRadius = 5
        resultsChallengeButton.layer.masksToBounds = true
        resultsChallengeButton.setTitle("Challenges", forState: UIControlState.Normal)
        
        resultsTimelineButton = UIButton(frame:CGRectZero)
        resultsTimelineButton.addTarget(self, action: "resultTimelineAction", forControlEvents: UIControlEvents.TouchUpInside)
        resultsTimelineButton.backgroundColor = UIColor.blueColor()
        resultsTimelineButton.layer.cornerRadius = 5
        resultsTimelineButton.layer.masksToBounds = true
        resultsTimelineButton.setTitle("Timeline", forState: UIControlState.Normal)
        

        //challenge type buttons
        newChallengeButton = UIButton(frame:CGRectZero)
        newChallengeButton.addTarget(self, action: "newChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        newChallengeButton.backgroundColor = UIColor.blueColor()
        newChallengeButton.layer.cornerRadius = 5
        newChallengeButton.layer.masksToBounds = true
        newChallengeButton.setTitle("New", forState: UIControlState.Normal)
        newChallengeButton.alpha = 0
        
        pendingChallengesButton = UIButton(frame:CGRectZero)
        pendingChallengesButton.addTarget(self, action: "pendingChallengesAction", forControlEvents: UIControlEvents.TouchUpInside)
        pendingChallengesButton.backgroundColor = UIColor.blueColor()
        pendingChallengesButton.layer.cornerRadius = 5
        pendingChallengesButton.layer.masksToBounds = true
        pendingChallengesButton.setTitle("Pending", forState: UIControlState.Normal)
        pendingChallengesButton.alpha = 0
        
        
        // Do any additional setup after loading the view, typically from a nib.
        dynamicPlayButton = UIButton(frame:CGRectZero)
        //dynamicPlayButton.addTarget(self, action: "playAction", forControlEvents: UIControlEvents.TouchUpInside)
        dynamicPlayButton.backgroundColor = UIColor.blueColor()
        dynamicPlayButton.layer.cornerRadius = 5
        dynamicPlayButton.layer.masksToBounds = true
        dynamicPlayButton.setTitle("Play", forState: UIControlState.Normal)

        playButtonExstraLabel = UILabel(frame:CGRectZero)
        playButtonExstraLabel.backgroundColor = dynamicPlayButton.backgroundColor?.colorWithAlphaComponent(0)
        playButtonExstraLabel.textColor = UIColor.whiteColor()
        playButtonExstraLabel.font = UIFont.systemFontOfSize(12)
        playButtonExstraLabel.textAlignment = NSTextAlignment.Center
        dynamicPlayButton.addSubview(playButtonExstraLabel)

        playButtonExstraLabel2 = UILabel(frame:CGRectZero)
        playButtonExstraLabel2.backgroundColor = dynamicPlayButton.backgroundColor?.colorWithAlphaComponent(0)
        playButtonExstraLabel2.textColor = UIColor.whiteColor()
        playButtonExstraLabel2.font = UIFont.systemFontOfSize(12)
        playButtonExstraLabel2.textAlignment = NSTextAlignment.Center
        dynamicPlayButton.addSubview(playButtonExstraLabel2)
        
        
        
        timelineButton = UIButton(frame:CGRectZero)
        timelineButton.setTitle("Timeline", forState: UIControlState.Normal)
        timelineButton.addTarget(self, action: "timelineAction", forControlEvents: UIControlEvents.TouchUpInside)
        timelineButton.backgroundColor = UIColor.blueColor()
        timelineButton.layer.cornerRadius = 5
        timelineButton.layer.masksToBounds = true

        
        
        levelSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        levelSlider.curvaceousness = 0.0
        levelSlider.maximumValue = Double(GlobalConstants.maxLevel) + 0.5
        levelSlider.minimumValue = Double(GlobalConstants.minLevel)
        levelSlider.typeValue = sliderType.bothLowerAndUpper
        levelSlider.lowerValue = 1
        levelSlider.upperValue = 2

        
        borderSwitch = UISwitch(frame: CGRectZero)
        borderSwitch.on = false
        borderSwitch.addTarget(self, action: "borderStateChanged:", forControlEvents: UIControlEvents.TouchUpInside)
        borderSwitch.alpha = 0
        
        borderSwitchLabel = UILabel(frame: CGRectZero)
        borderSwitchLabel.font = UIFont.boldSystemFontOfSize(24)
        borderSwitchLabel.adjustsFontSizeToFitWidth = true
        borderSwitchLabel.textAlignment = NSTextAlignment.Center
        borderSwitchLabel.text = "Without borders"
        borderSwitchLabel.alpha = 0

        
        selectFilterTypeButton = UIButton(frame: CGRectZero)
        selectFilterTypeButton.setTitle("📋", forState: UIControlState.Normal)
        selectFilterTypeButton.layer.borderColor = UIColor.blueColor().CGColor
        selectFilterTypeButton.addTarget(self, action: "openFilterList", forControlEvents: UIControlEvents.TouchUpInside)
        selectFilterTypeButton.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0)

        dynamicPlayButton.alpha = 0
        levelSlider.alpha = 0
        selectFilterTypeButton.alpha = 0
        
        resultsChallengeButton.alpha = 0
        resultsTimelineButton.alpha = 0

        self.view.addSubview(challengeUsersButton)
        self.view.addSubview(practiceButton)
        self.view.addSubview(resultsButton)
        self.view.addSubview(adFreeButton)
        
        self.view.addSubview(newChallengeButton)
        self.view.addSubview(pendingChallengesButton)
        
        self.view.addSubview(self.resultsTimelineButton)
        self.view.addSubview(self.resultsChallengeButton)
        
        self.view.addSubview(dynamicPlayButton)
        self.view.addSubview(levelSlider)
        self.view.addSubview(selectFilterTypeButton)
        self.view.addSubview(borderSwitchLabel)
        self.view.addSubview(borderSwitch)
        
        
        setupCheckboxView()
        
        
        if firstLaunch
        {
            if Int(datactrl.dataPopulatedValue as! NSNumber) <= 0
            {
                loadingDataLabel = UILabel(frame: CGRectMake(0, 0, 200, 50))
                loadingDataLabel.text = "Loading data.."
                loadingDataLabel.textAlignment = NSTextAlignment.Center
                loadingDataView = UIView(frame: CGRectMake(50, 50, 200, 50))
                loadingDataView.backgroundColor = UIColor.redColor()
                loadingDataView.addSubview(loadingDataLabel)
                self.view.addSubview(loadingDataView)
                
                let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "opacity");
                pulseAnimation.duration = 0.3
                pulseAnimation.toValue = NSNumber(float: 0.3)
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = 100
                pulseAnimation.delegate = self
                loadingDataView.layer.addAnimation(pulseAnimation, forKey: "asd")
            }
        }
        else
        {
            allowRotate = true
            self.challengeUsersButton.alpha = 1
            self.practiceButton.alpha = 1
            self.resultsButton.alpha = 1
            self.adFreeButton.alpha = 1
            
            requestProductData()
            //setupAfterPopulateData()
        }

        //setupAfterPopulateData()

    }
    
    func borderStateChanged(switchState: UISwitch) {
        if switchState.on {
            borderSwitchLabel.text = "With borders"
        } else {
            borderSwitchLabel.text = "Without borders"
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        bannerView?.delegate = nil
        bannerView?.removeFromSuperview()
    }
    
    override func viewDidAppear(animated: Bool) {

        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")
        if firstLaunch
        {
            holderView = HolderView(frame: view.bounds)
            holderView.delegate = self
            view.addSubview(holderView)
            holderView.startAnimation()

            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "firstlaunch")
        }

    }
    
    func loadScreenFinished() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        //_?
        //holderView.removeFromSuperview()
        holderView.hidden = true
        allowRotate = true
        
        challengeUsersButton.transform = CGAffineTransformScale(challengeUsersButton.transform, 0.1, 0.1)
        practiceButton.transform = CGAffineTransformScale(practiceButton.transform, 0.1, 0.1)
        resultsButton.transform = CGAffineTransformScale(resultsButton.transform, 0.1, 0.1)
        adFreeButton.transform = CGAffineTransformScale(adFreeButton.transform, 0.1, 0.1)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.challengeUsersButton.alpha = 1
            self.practiceButton.alpha = 1
            self.resultsButton.alpha = 1
            self.adFreeButton.alpha = 1
            self.challengeUsersButton.transform = CGAffineTransformIdentity
            self.practiceButton.transform = CGAffineTransformIdentity
            self.resultsButton.transform = CGAffineTransformIdentity
            self.adFreeButton.transform = CGAffineTransformIdentity
            }, completion: { (value: Bool) in
                self.view.backgroundColor = UIColor.whiteColor()
        })
        requestProductData()
        populateDataIfNeeded()
    }
    
    func populateDataIfNeeded()
    {
        if Int(datactrl.dataPopulatedValue as! NSNumber) <= 0
        {
            
            datactrl.populateData({ () in
                
                
                self.loadingDataView.alpha = 0
                self.loadingDataView.layer.removeAllAnimations()
            })
            
            loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        }
    }
    
    
    override func viewDidLayoutSubviews() {

        //bannerView?.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height - 44, UIScreen.mainScreen().bounds.size.width, 44)
        
        loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)

        setupFirstLevelMenu()
        
        setupChallengeTypeButtons()
        
        setupDynamicPlayButton()
        
        setupResultButtons()

        closeTagCheckView()

    }
    
    func setupFirstLevelMenu()
    {
        let marginButtons:CGFloat = 10
        var buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.17
        let buttonHeight = buttonWidth
        let orientation = UIDevice.currentDevice().orientation
        //if orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight
        if orientation.isLandscape || orientation.isFlat
        {
            challengeUsersButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - buttonWidth - (marginButtons / 2), UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight)
            practiceButton.frame = CGRectMake(challengeUsersButton.frame.maxX + marginButtons, UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight)
            
            resultsButton.frame = CGRectMake(challengeUsersButton.frame.minX, challengeUsersButton.frame.maxY + marginButtons, buttonWidth, buttonHeight)
            
            adFreeButton.frame = CGRectMake(practiceButton.frame.minX, resultsButton.frame.minY, buttonWidth, buttonHeight)
        }
        else
        {
            buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.65
            challengeUsersButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (buttonWidth / 2), UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight)
            practiceButton.frame = CGRectMake(challengeUsersButton.frame.minX, challengeUsersButton.frame.maxY + marginButtons, buttonWidth, buttonHeight)
            
            resultsButton.frame = CGRectMake(challengeUsersButton.frame.minX, practiceButton.frame.maxY + marginButtons, buttonWidth, buttonHeight)
            
            adFreeButton.frame = CGRectMake(challengeUsersButton.frame.minX, resultsButton.frame.maxY + marginButtons, buttonWidth, buttonHeight)
            
            
        }
        

    }
    
    func setupDynamicPlayButton()
    {
        let margin: CGFloat = 20.0
        let sliderAndFilterbuttonHeight:CGFloat = 31.0
        
        let orientation = UIDevice.currentDevice().orientation

        var playbuttonWidth = self.practiceButton.frame.maxX - self.challengeUsersButton.frame.minX
        var playbuttonHeight = self.resultsButton.frame.maxY - self.challengeUsersButton.frame.minY - sliderAndFilterbuttonHeight - margin

        if orientation.isLandscape || orientation.isFlat
        {
            playbuttonWidth = UIScreen.mainScreen().bounds.size.width * 0.7
            playbuttonHeight = UIScreen.mainScreen().bounds.size.height * 0.33
            
            dynamicPlayButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width - playbuttonWidth)  / 2, self.challengeUsersButton.frame.minY,playbuttonWidth, playbuttonHeight)
            let marginSlider: CGFloat = dynamicPlayButton.frame.minX
            
            playButtonExstraLabel.frame = CGRectMake(0, dynamicPlayButton.frame.height * 0.7   , dynamicPlayButton.frame.width, dynamicPlayButton.frame.height * 0.15)
            playButtonExstraLabel.text = "level \(Int(levelSlider.lowerValue)) - \(sliderUpperLevelText())"
            playButtonExstraLabel2.frame = CGRectMake(0, dynamicPlayButton.frame.height * 0.85   , dynamicPlayButton.frame.width, dynamicPlayButton.frame.height * 0.15)
            
            
            levelSlider.frame = CGRect(x:  marginSlider, y: dynamicPlayButton.frame.maxY  + margin, width: UIScreen.mainScreen().bounds.size.width - (marginSlider * 2) - (dynamicPlayButton.frame.width * 0.2), height: sliderAndFilterbuttonHeight)
            
            selectFilterTypeButton.frame = CGRectMake(levelSlider.frame.maxX, dynamicPlayButton.frame.maxY + margin, UIScreen.mainScreen().bounds.size.width * 0.2, levelSlider.frame.height)
            
            
        }
        else
        {
            dynamicPlayButton.frame = CGRectMake(self.challengeUsersButton.frame.minX, self.challengeUsersButton.frame.minY,playbuttonWidth, playbuttonHeight)
            let marginSlider: CGFloat = dynamicPlayButton.frame.minX
            
            playButtonExstraLabel.frame = CGRectMake(0, dynamicPlayButton.frame.height * 0.7   , dynamicPlayButton.frame.width, dynamicPlayButton.frame.height * 0.15)
            playButtonExstraLabel.text = "level \(Int(levelSlider.lowerValue)) - \(sliderUpperLevelText())"
            playButtonExstraLabel2.frame = CGRectMake(0, dynamicPlayButton.frame.height * 0.85   , dynamicPlayButton.frame.width, dynamicPlayButton.frame.height * 0.15)
            
            levelSlider.frame = CGRect(x:  marginSlider, y: dynamicPlayButton.frame.maxY  + margin, width: UIScreen.mainScreen().bounds.size.width - (marginSlider * 2) - (dynamicPlayButton.frame.width * 0.2), height: sliderAndFilterbuttonHeight)
            
            selectFilterTypeButton.frame = CGRectMake(levelSlider.frame.maxX, dynamicPlayButton.frame.maxY + margin, UIScreen.mainScreen().bounds.size.width * 0.2, levelSlider.frame.height)
            
            let borderElementWidth1 = playButtonExstraLabel.frame.width * 0.6
            let borderElementWidth2 = playButtonExstraLabel.frame.width * 0.33
            borderSwitchLabel.frame = CGRectMake(levelSlider.frame.minX, levelSlider.frame.maxY + margin, borderElementWidth1, levelSlider.frame.height)
            borderSwitch.frame = CGRectMake(dynamicPlayButton.frame.maxX - borderElementWidth2, levelSlider.frame.maxY + margin, borderElementWidth2, levelSlider.frame.height)
        }
        

    }
    
    func setupChallengeTypeButtons()
    {
        //newChallengeButton.alpha = 1
        //pendingChallengesButton.alpha = 1
        let buttonMargin: CGFloat = 20.0
        let orientation = UIDevice.currentDevice().orientation
        var buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.17
        var buttonHeight = buttonWidth
        if orientation.isLandscape || orientation.isFlat
        {
            buttonHeight = (buttonWidth * 2) + buttonMargin
            newChallengeButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) -  buttonWidth - (buttonMargin / 2), UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight)
            pendingChallengesButton.frame = CGRectMake(self.newChallengeButton.frame.maxX + buttonMargin, self.newChallengeButton.frame.minY, buttonWidth, buttonHeight)
        }
        else
        {
            buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.65
            buttonHeight = UIScreen.mainScreen().bounds.size.height * 0.35
            newChallengeButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - ( buttonWidth / 2), UIScreen.mainScreen().bounds.size.height * 0.15,buttonWidth, buttonHeight)
            pendingChallengesButton.frame = CGRectMake(self.newChallengeButton.frame.minX, self.newChallengeButton.frame.maxY + buttonMargin, buttonWidth, buttonHeight)
        }
    }
    
    func setupResultButtons()
    {

        let buttonMargin: CGFloat = 20.0
        var buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.17
        var buttonHeight = buttonWidth
        let orientation = UIDevice.currentDevice().orientation
        if orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight
        {
            buttonHeight = (buttonWidth * 2) + buttonMargin

            resultsChallengeButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) -  buttonWidth - (buttonMargin / 2), UIScreen.mainScreen().bounds.size.height * 0.15, buttonWidth, buttonHeight)
            resultsTimelineButton.frame = CGRectMake(self.resultsChallengeButton.frame.maxX + buttonMargin, self.resultsChallengeButton.frame.minY, buttonWidth, buttonHeight)
        }
        else
        {
            buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.65
            buttonHeight = UIScreen.mainScreen().bounds.size.height * 0.35
            resultsChallengeButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - ( buttonWidth / 2), UIScreen.mainScreen().bounds.size.height * 0.15,buttonWidth, buttonHeight)
            resultsTimelineButton.frame = CGRectMake(self.resultsChallengeButton.frame.minX, self.resultsChallengeButton.frame.maxY + buttonMargin, buttonWidth, buttonHeight)
        }
    }
    
    func sliderUpperLevelText() -> String
    {
        return Int(levelSlider.upperValue) > 4 ? "Ridiculous" : "\(Int(levelSlider.upperValue))"
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rangeSliderValueChanged(slider: RangeSlider) {
        //println("Range slider value changed: (\(Int(slider.lowerValue)) \(Int(slider.upperValue)))")
        playButtonExstraLabel.text = "level \(Int(slider.lowerValue)) - \(sliderUpperLevelText())"
    }
    
    func resultAction()
    {
        self.resultsChallengeButton.transform = CGAffineTransformScale(self.resultsChallengeButton.transform, 0.1, 0.1)
        self.resultsTimelineButton.transform = CGAffineTransformScale(self.resultsTimelineButton.transform, 0.1, 0.1)
        let centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.challengeUsersButton.center = centerScreen
            self.challengeUsersButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.practiceButton.center = centerScreen
            self.practiceButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.resultsButton.center = centerScreen
            self.resultsButton.transform = CGAffineTransformScale(self.resultsButton.transform, 0.1, 0.1)
            self.adFreeButton.center = centerScreen
            self.adFreeButton.transform = CGAffineTransformScale(self.adFreeButton.transform, 0.1, 0.1)

            
            }, completion: { (value: Bool) in
                
                self.challengeUsersButton.alpha = 0
                self.practiceButton.alpha = 0
                self.resultsButton.alpha = 0
                self.adFreeButton.alpha = 0
                
                self.resultsChallengeButton.alpha = 1
                self.resultsTimelineButton.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.resultsChallengeButton.transform = CGAffineTransformIdentity
                    self.resultsTimelineButton.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                })
        })
    }
    
    
    func playPracticeAction()
    {
        gametype = gameType.training
        self.performSegueWithIdentifier("segueFromMainMenuToPlay", sender: nil)
    }

    
    func practiceAction()
    {
        dynamicPlayButton.setTitle("Practice", forState: UIControlState.Normal)
        dynamicPlayButton.addTarget(self, action: "playPracticeAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.dynamicPlayButton.alpha = 0
        self.dynamicPlayButton.transform = CGAffineTransformScale(self.dynamicPlayButton.transform, 0.1, 0.1)
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        self.selectFilterTypeButton.alpha = 0
        self.selectFilterTypeButton.transform = CGAffineTransformScale(self.selectFilterTypeButton.transform, 0.1, 0.1)
        self.borderSwitchLabel.alpha = 0
        self.borderSwitchLabel.transform = CGAffineTransformScale(self.borderSwitchLabel.transform, 0.1, 0.1)
        self.borderSwitch.alpha = 0
        self.borderSwitch.transform = CGAffineTransformScale(self.borderSwitchLabel.transform, 0.1, 0.1)
        
        let centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.challengeUsersButton.center = centerScreen
            self.challengeUsersButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.practiceButton.center = centerScreen
            self.practiceButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.resultsButton.center = centerScreen
            self.resultsButton.transform = CGAffineTransformScale(self.resultsButton.transform, 0.1, 0.1)
            self.adFreeButton.center = centerScreen
            self.adFreeButton.transform = CGAffineTransformScale(self.adFreeButton.transform, 0.1, 0.1)
            
            }, completion: { (value: Bool) in
                
                self.challengeUsersButton.alpha = 0
                self.practiceButton.alpha = 0
                self.resultsButton.alpha = 0
                self.adFreeButton.alpha = 0
                
                self.dynamicPlayButton.alpha = 1
                self.levelSlider.alpha = 1
                self.selectFilterTypeButton.alpha = 1
                
                self.borderSwitchLabel.alpha = 1
                self.borderSwitch.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.dynamicPlayButton.transform = CGAffineTransformIdentity
                    self.levelSlider.transform = CGAffineTransformIdentity
                    self.selectFilterTypeButton.transform = CGAffineTransformIdentity
                    self.borderSwitchLabel.transform = CGAffineTransformIdentity
                    self.borderSwitch.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                        
                        
                })
        })
    }
    
    func newChallengeAction()
    {
        dynamicPlayButton.titleLabel?.numberOfLines = 2
        dynamicPlayButton.titleLabel?.textAlignment = NSTextAlignment.Center
        dynamicPlayButton.setTitle("New challenge\n\(numOfQuestionsForRound) questions", forState: UIControlState.Normal)
        dynamicPlayButton.addTarget(self, action: "playNewChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.dynamicPlayButton.alpha = 0
        self.dynamicPlayButton.transform = CGAffineTransformScale(self.dynamicPlayButton.transform, 0.1, 0.1)
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        self.selectFilterTypeButton.alpha = 0
        self.selectFilterTypeButton.transform = CGAffineTransformScale(self.selectFilterTypeButton.transform, 0.1, 0.1)
        self.borderSwitchLabel.alpha = 0
        self.borderSwitchLabel.transform = CGAffineTransformScale(self.borderSwitchLabel.transform, 0.1, 0.1)
        self.borderSwitch.alpha = 0
        self.borderSwitch.transform = CGAffineTransformScale(self.borderSwitchLabel.transform, 0.1, 0.1)
        
        let centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.newChallengeButton.center = centerScreen
            self.newChallengeButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.pendingChallengesButton.center = centerScreen
            self.pendingChallengesButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            
            }, completion: { (value: Bool) in
                
                self.newChallengeButton.alpha = 0
                self.pendingChallengesButton.alpha = 0
                
                self.dynamicPlayButton.alpha = 1
                self.levelSlider.alpha = 1
                self.selectFilterTypeButton.alpha = 1
                
                self.borderSwitchLabel.alpha = 1
                self.borderSwitch.alpha = 1
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.dynamicPlayButton.transform = CGAffineTransformIdentity
                    self.levelSlider.transform = CGAffineTransformIdentity
                    self.selectFilterTypeButton.transform = CGAffineTransformIdentity
                    self.borderSwitchLabel.transform = CGAffineTransformIdentity
                    self.borderSwitch.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                        
                })
        })
    }
    
    func playNewChallengeAction()
    {
        gametype = gameType.makingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func pendingChallengesAction()
    {
        gametype = gameType.takingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func challengeAction()
    {

        self.newChallengeButton.transform = CGAffineTransformScale(self.newChallengeButton.transform, 0.1, 0.1)
        self.pendingChallengesButton.transform = CGAffineTransformScale(self.pendingChallengesButton.transform, 0.1, 0.1)
        
        let centerScreen = CGPointMake(UIScreen.mainScreen().bounds.size.width / 2, UIScreen.mainScreen().bounds.size.height / 2)
        UIView.animateWithDuration(0.2, animations: { () -> Void in

            
            self.challengeUsersButton.center = centerScreen
            self.challengeUsersButton.transform = CGAffineTransformScale(self.challengeUsersButton.transform, 0.1, 0.1)
            self.practiceButton.center = centerScreen
            self.practiceButton.transform = CGAffineTransformScale(self.practiceButton.transform, 0.1, 0.1)
            self.resultsButton.center = centerScreen
            self.resultsButton.transform = CGAffineTransformScale(self.resultsButton.transform, 0.1, 0.1)
            self.adFreeButton.center = centerScreen
            self.adFreeButton.transform = CGAffineTransformScale(self.adFreeButton.transform, 0.1, 0.1)
            
            }, completion: { (value: Bool) in
                
                self.challengeUsersButton.alpha = 0
                self.practiceButton.alpha = 0
                self.resultsButton.alpha = 0
                self.adFreeButton.alpha = 0
                
                self.newChallengeButton.alpha = 1
                self.pendingChallengesButton.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.newChallengeButton.transform = CGAffineTransformIdentity
                    self.pendingChallengesButton.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                        print("test4 \(self.pendingChallengesButton.frame.width) \(self.pendingChallengesButton.frame.height)")
                })
        })

    }
    
    func resultChallengeAction()
    {
        self.performSegueWithIdentifier("segueFromMainMenuToChallengeResults", sender: nil)
    }
    
    func resultTimelineAction()
    {
        self.performSegueWithIdentifier("segueFromMainMenuToTimeline", sender: nil)
    }
    
    override func prepareForSegue(segue: (UIStoryboardSegue!), sender: AnyObject!) {
        
        if (segue.identifier == "segueFromMainMenuToPlay") {
            let svc = segue!.destinationViewController as! PlayViewController
            print("\(levelSlider.upperValue)")
            svc.levelLow = Int(levelSlider.lowerValue)
            svc.levelHigh = Int(levelSlider.upperValue)
            svc.tags = self.tags
            svc.gametype = gametype
            svc.drawBorders = borderSwitch.on
        }
        
        if (segue.identifier == "segueFromMainMenuToChallenge") {
            let svc = segue!.destinationViewController as! ChallengeViewController
            svc.passingLevelLow = Int(levelSlider.lowerValue)
            svc.passingLevelHigh = Int(levelSlider.upperValue)
            svc.passingTags = self.tags
            svc.numOfQuestionsForRound = self.numOfQuestionsForRound
            svc.gametype = self.gametype
            svc.drawBorders = borderSwitch.on
        }
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        self.bannerView?.hidden = adFree
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        self.bannerView?.hidden = adFree
    }

    //MARK: TagCheckViewProtocol
    var listClosed = true
    func closeTagCheckView()
    {
        if listClosed
        {
            return
        }
        
        if self.tags.count < 1
        {
            let numberPrompt = UIAlertController(title: "Pick 1",
                message: "Select at least 1 tags",
                preferredStyle: .Alert)
            
            
            numberPrompt.addAction(UIAlertAction(title: "Ok",
                style: .Default,
                handler: { (action) -> Void in
                    
            }))
            
            
            self.presentViewController(numberPrompt,
                animated: true,
                completion: nil)
        }
        else
        {

            let rightLocation = tagsScrollView.center
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                self.tagsScrollView.transform = CGAffineTransformScale(self.tagsScrollView.transform, 0.1, 0.1)
                
                self.tagsScrollView.center = self.selectFilterTypeButton.center
                }, completion: { (value: Bool) in
                    self.tagsScrollView.transform = CGAffineTransformScale(self.tagsScrollView.transform, 0.1, 0.1)
                    self.tagsScrollView.alpha = 0
                    self.tagsScrollView.center = rightLocation
                    self.listClosed = true
                    self.tagsScrollViewEnableBackground.alpha = 0
            })
        }
    }
    
    func reloadMarks(tags:[String])
    {
        self.tags = tags
    }
    
    func setupCheckboxView()
    {
        let bannerViewHeight = bannerView != nil ? bannerView!.frame.height : 0
        tagsScrollViewEnableBackground = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - bannerViewHeight))
        tagsScrollViewEnableBackground.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.5)
        tagsScrollViewEnableBackground.alpha = 0
        var scrollViewWidth = UIScreen.mainScreen().bounds.size.width * 0.6
        let orientation = UIDevice.currentDevice().orientation
        if orientation == UIDeviceOrientation.LandscapeLeft || orientation == UIDeviceOrientation.LandscapeRight
        {
            scrollViewWidth = UIScreen.mainScreen().bounds.size.width / 2
        }
        tagsScrollView = TagCheckScrollView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (scrollViewWidth / 2) , UIScreen.mainScreen().bounds.size.height / 4, scrollViewWidth, UIScreen.mainScreen().bounds.size.height / 2))
        tagsScrollView.delegate = self
        tagsScrollView.alpha = 0
        tagsScrollViewEnableBackground.addSubview(tagsScrollView!)
        view.addSubview(tagsScrollViewEnableBackground)
    }
    
    func openFilterList()
    {
        let rightLocation = tagsScrollView.center
        tagsScrollView.transform = CGAffineTransformScale(tagsScrollView.transform, 0.1, 0.1)
        self.tagsScrollView.alpha = 1
        tagsScrollView.center = selectFilterTypeButton.center
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.tagsScrollViewEnableBackground.alpha = 1
            self.tagsScrollView.transform = CGAffineTransformIdentity
            
            self.tagsScrollView.center = rightLocation
            }, completion: { (value: Bool) in
                self.tagsScrollView.transform = CGAffineTransformIdentity
                self.tagsScrollView.alpha = 1
                self.tagsScrollView.center = rightLocation
                self.listClosed = false
        })
        
    }
    
    
    //MARK addRemove
    
    func requestProductData()
    {
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        if adFree
        {
            return
        }
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:  NSSet(objects: self.productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count != 0) {
            product = products[0]
            //buyButton.enabled = true
            //productTitle.text = product!.localizedTitle
            //productDescription.text = product!.localizedDescription
            
            adFreeButton.backgroundColor = UIColor.blueColor()
            adFreeButton.userInteractionEnabled = true
            
        } else {
            //productTitle.text = "Product not found"
        }
        
        let invalidProducts = response.invalidProductIdentifiers
        
        for product in invalidProducts
        {
            print("Product not found: \(product)")
        }
    }
    
    func buyProductAction() {

        let payment = SKPayment(product: product!)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        
        for transaction in transactions as! [SKPaymentTransaction] {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                self.removeAdds()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case SKPaymentTransactionState.Restored:
                self.removeAdds()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case SKPaymentTransactionState.Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func removeAdds() {
        
        datactrl.adFreeValue = 1
        datactrl.saveGameData()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "adFree")
        self.bannerView?.hidden = true
        
        adFreeButton.backgroundColor = UIColor.grayColor()
        adFreeButton.userInteractionEnabled = false
        adFreeButton.setTitle(" ", forState: UIControlState.Normal)
    }

    var allowRotate = false
    override func shouldAutorotate() -> Bool {
        return allowRotate
    }
    
    func canRotate () -> Void{ }
    

}

