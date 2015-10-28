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

class MainMenuViewController: UIViewController, TagCheckViewProtocol , ADBannerViewDelegate, HolderViewDelegate,SKProductsRequestDelegate, StatsViewProtocol {


    //payment
    var product: SKProduct?
    var productID = "TimelineFeudAddFree1234"
    
    //buttons
    var challengeUsersButton:UIButton!
    var resultsButton:UIButton!
    
    var practicePlayButton:UIButton!
    var challengePlayButton:UIButton!
    
    
    var pendingChallengesButton:UIButton!
    var newChallengeButton:UIButton!
    var practiceButton:UIButton!
    var selectFilterTypeButton:UIButton!
    
    var practicePlayButtonExstraLabel:UILabel!
    var challengePlayButtonExstraLabel:UILabel!
    var borderSwitch:UISwitch!
    var borderSwitchLabel:UILabel!
    var statsView:StatsView!
    
    
    var loadingDataView:UIView!
    var loadingDataLabel:UILabel!
    var datactrl:DataHandler!
    var tagsScrollViewEnableBackground:UIView!
    var tagsScrollView:TagCheckScrollView!
    
    let queue = NSOperationQueue()
    
    var updateGlobalGameStats:Bool = false
    var newGameStatsValues:(Int,Int)!

    let levelSlider = RangeSlider(frame: CGRectZero)
    var gametype:GameType!
    var tags:[String] = []
    
    var holderView:HolderView!
    
    var numOfQuestionsForRound:Int = 3
    
    var removeAdsButton:UIButton?
    
    var bannerView:ADBannerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstLaunch = NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch")

        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl

        let marginButtons:CGFloat = 10
        var buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.17
        let buttonHeight = buttonWidth
        buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.65
        
        challengeUsersButton = MenuButton(frame:CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (buttonWidth / 2), (UIScreen.mainScreen().bounds.size.height * 0.33) + buttonHeight + marginButtons, buttonWidth, buttonHeight),title:"Challenge")
        challengeUsersButton.addTarget(self, action: "challengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        challengeUsersButton.alpha = 0
        
        
        practiceButton = MenuButton(frame:CGRectMake(challengeUsersButton.frame.minX, challengeUsersButton.frame.maxY + marginButtons, buttonWidth, buttonHeight),title:"Practice")
        practiceButton.addTarget(self, action: "practiceAction", forControlEvents: UIControlEvents.TouchUpInside)
        practiceButton.alpha = 0
        
        resultsButton = MenuButton(frame:CGRectMake(practiceButton.frame.minX, practiceButton.frame.maxY + marginButtons, buttonWidth, buttonHeight),title:"Results")
        resultsButton.addTarget(self, action: "resultChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        resultsButton.alpha = 0
        

        
        let adFree = NSUserDefaults.standardUserDefaults().boolForKey("adFree")
        if !adFree
        {
            removeAdsButton = UIButton(frame: CGRectMake(0, 0, practiceButton.frame.width * 0.66,  practiceButton.frame.height))
            removeAdsButton?.center = CGPointMake(UIScreen.mainScreen().bounds.width / 2,resultsButton.frame.maxY)
            removeAdsButton?.setTitle("Remove ads ☂ ", forState: UIControlState.Normal)
            removeAdsButton?.backgroundColor = UIColor.blueColor()
            removeAdsButton?.layer.cornerRadius = 3 //label.bounds.size.width / 2
            removeAdsButton?.layer.masksToBounds = true
            removeAdsButton?.alpha = 0
            self.view.addSubview(removeAdsButton!)
            
            self.canDisplayBannerAds = true
            bannerView = ADBannerView(frame: CGRectZero)
            bannerView!.center = CGPoint(x: bannerView!.center.x, y: self.view.bounds.size.height - bannerView!.frame.size.height / 2)
            self.view.addSubview(bannerView!)
            self.bannerView?.delegate = self
            self.bannerView?.hidden = false
        }
        
        let statsViewHeight = UIScreen.mainScreen().bounds.height * 0.1
        statsView = StatsView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, statsViewHeight))
        statsView.delegate = self
        self.view.addSubview(statsView)
        

        //challenge type buttons
        newChallengeButton = UIButton(frame:CGRectZero)
        newChallengeButton.titleLabel?.numberOfLines = 2
        newChallengeButton.titleLabel?.textAlignment = NSTextAlignment.Center
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
        practicePlayButton = UIButton(frame:CGRectZero)
        practicePlayButton.setTitle("Practice", forState: UIControlState.Normal)
        practicePlayButton.addTarget(self, action: "playPracticeAction", forControlEvents: UIControlEvents.TouchUpInside)
        practicePlayButton.backgroundColor = UIColor.blueColor()
        practicePlayButton.layer.cornerRadius = 5
        practicePlayButton.layer.masksToBounds = true
        
        challengePlayButton = UIButton(frame:CGRectZero)
        challengePlayButton.setTitle("New challenge\n\(numOfQuestionsForRound) questions", forState: UIControlState.Normal)
        challengePlayButton.titleLabel!.numberOfLines = 2
        challengePlayButton.addTarget(self, action: "playNewChallengeAction", forControlEvents: UIControlEvents.TouchUpInside)
        challengePlayButton.backgroundColor = UIColor.blueColor()
        challengePlayButton.layer.cornerRadius = 5
        challengePlayButton.layer.masksToBounds = true

        challengePlayButtonExstraLabel = UILabel(frame:CGRectZero)
        challengePlayButtonExstraLabel.backgroundColor = challengePlayButton.backgroundColor?.colorWithAlphaComponent(0)
        challengePlayButtonExstraLabel.textColor = UIColor.whiteColor()
        challengePlayButtonExstraLabel.font = UIFont.systemFontOfSize(12)
        challengePlayButtonExstraLabel.textAlignment = NSTextAlignment.Center
        challengePlayButton.addSubview(challengePlayButtonExstraLabel)
        
        
        
        practicePlayButtonExstraLabel = UILabel(frame:CGRectZero)
        practicePlayButtonExstraLabel.backgroundColor = practicePlayButton.backgroundColor?.colorWithAlphaComponent(0)
        practicePlayButtonExstraLabel.textColor = UIColor.whiteColor()
        practicePlayButtonExstraLabel.font = UIFont.systemFontOfSize(12)
        practicePlayButtonExstraLabel.textAlignment = NSTextAlignment.Center
        practicePlayButton.addSubview(practicePlayButtonExstraLabel)

        
        
        
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

        practicePlayButton.alpha = 0
        challengePlayButton.alpha = 0
        levelSlider.alpha = 0
        selectFilterTypeButton.alpha = 0

        self.view.addSubview(challengeUsersButton)
        self.view.addSubview(practiceButton)
        self.view.addSubview(resultsButton)
        
        self.view.addSubview(newChallengeButton)
        self.view.addSubview(pendingChallengesButton)

        
        self.view.addSubview(practicePlayButton)
        self.view.addSubview(challengePlayButton)
        self.view.addSubview(levelSlider)
        self.view.addSubview(selectFilterTypeButton)
        self.view.addSubview(borderSwitchLabel)
        self.view.addSubview(borderSwitch)
        
        
        setupCheckboxView()
        
        loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        setupFirstLevelMenu()
        setupChallengeTypeButtons()
        setupDynamicPlayButton()
        closeTagCheckView()
        
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
            self.removeAdsButton?.alpha = 1
            
            requestProductData()
            //setupAfterPopulateData()
        }

        //setupAfterPopulateData()

    }
    
    
    func buyAdFree()
    {
        removeAdsButton!.removeFromSuperview()
        datactrl.adFreeValue = 1
        datactrl.saveGameData()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "adFree")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        bannerView?.frame.offsetInPlace(dx: 0, dy: bannerView!.frame.height)
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
        removeAdsButton?.transform = CGAffineTransformScale(removeAdsButton!.transform, 0.1, 0.1)
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.challengeUsersButton.alpha = 1
            self.practiceButton.alpha = 1
            self.resultsButton.alpha = 1
            self.removeAdsButton?.alpha = 1
            self.challengeUsersButton.transform = CGAffineTransformIdentity
            self.practiceButton.transform = CGAffineTransformIdentity
            self.resultsButton.transform = CGAffineTransformIdentity
            self.removeAdsButton?.transform = CGAffineTransformIdentity
            }, completion: { (value: Bool) in
                self.view.backgroundColor = UIColor.whiteColor()
        })
        requestProductData()
        populateDataIfNeeded()
        
        //test _?
        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
        datactrl.adFreeValue = 0
        datactrl.timeBounusValue = 0
        datactrl.saveGameData()
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "adFree")
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "timeBonus")
        NSUserDefaults.standardUserDefaults().synchronize()
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

        /*
        loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        setupFirstLevelMenu()
        setupChallengeTypeButtons()
        setupDynamicPlayButton()
        closeTagCheckView()
        */
    }
    
    func setupFirstLevelMenu()
    {
        let marginButtons:CGFloat = 10
        var buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.17
        let buttonHeight = buttonWidth

        buttonWidth = UIScreen.mainScreen().bounds.size.width * 0.65
        challengeUsersButton.frame = CGRectMake((UIScreen.mainScreen().bounds.size.width / 2) - (buttonWidth / 2), UIScreen.mainScreen().bounds.size.height * 0.33, buttonWidth, buttonHeight)
        practiceButton.frame = CGRectMake(challengeUsersButton.frame.minX, challengeUsersButton.frame.maxY + marginButtons, buttonWidth, buttonHeight)
        
        resultsButton.frame = CGRectMake(challengeUsersButton.frame.minX, practiceButton.frame.maxY + marginButtons, buttonWidth, buttonHeight)
    }
    
    func setupDynamicPlayButton()
    {
        let margin: CGFloat = 20.0
        let sliderAndFilterbuttonHeight:CGFloat = 31.0

        let playbuttonWidth = self.practiceButton.frame.maxX - self.challengeUsersButton.frame.minX
        let playbuttonHeight = self.resultsButton.frame.maxY - self.challengeUsersButton.frame.minY - sliderAndFilterbuttonHeight - margin

        practicePlayButton.frame = CGRectMake(self.challengeUsersButton.frame.minX, self.challengeUsersButton.frame.minY,playbuttonWidth, playbuttonHeight)
        challengePlayButton.frame = practicePlayButton.frame
        
        print("challengePlayButton.frame \(challengePlayButton.frame.width) \(challengePlayButton.frame.height)")
        print("practicePlayButton.frame \(practicePlayButton.frame.width) \(practicePlayButton.frame.height)")
        
        let marginSlider: CGFloat = practicePlayButton.frame.minX
        
        practicePlayButtonExstraLabel.frame = CGRectMake(0, practicePlayButton.frame.height * 0.7   , practicePlayButton.frame.width, practicePlayButton.frame.height * 0.15)
        practicePlayButtonExstraLabel.text = "Level \(Int(levelSlider.lowerValue)) - \(sliderUpperLevelText())"
        
        challengePlayButtonExstraLabel.frame = CGRectMake(0, challengePlayButton.frame.height * 0.7   , practicePlayButton.frame.width, challengePlayButton.frame.height * 0.15)
        challengePlayButtonExstraLabel.text = "Level \(Int(levelSlider.lowerValue)) - \(sliderUpperLevelText())"

        
        levelSlider.frame = CGRect(x:  marginSlider, y: practicePlayButton.frame.maxY  + margin, width: UIScreen.mainScreen().bounds.size.width - (marginSlider * 2) - (practicePlayButton.frame.width * 0.2), height: sliderAndFilterbuttonHeight)
        
        selectFilterTypeButton.frame = CGRectMake(levelSlider.frame.maxX, practicePlayButton.frame.maxY + margin, UIScreen.mainScreen().bounds.size.width * 0.2, levelSlider.frame.height)
        
        let borderElementWidth1 = practicePlayButton.frame.width * 0.6
        let borderElementWidth2 = practicePlayButton.frame.width * 0.33
        borderSwitchLabel.frame = CGRectMake(levelSlider.frame.minX, levelSlider.frame.maxY + margin, borderElementWidth1, levelSlider.frame.height)
        borderSwitch.frame = CGRectMake(practicePlayButton.frame.maxX - borderElementWidth2, levelSlider.frame.maxY + margin, borderElementWidth2, levelSlider.frame.height)
        

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
    
    func sliderUpperLevelText() -> String
    {
        return Int(levelSlider.upperValue) > 4 ? "Ridiculous" : "\(Int(levelSlider.upperValue))"
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rangeSliderValueChanged(slider: RangeSlider) {
        
        if Int(slider.lowerValue) == Int(slider.upperValue)
        {
            let text = "Level \(sliderUpperLevelText())"
            practicePlayButtonExstraLabel.text = text
            challengePlayButtonExstraLabel.text = text
        }
        else
        {
            let text = "Level \(Int(slider.lowerValue)) - \(sliderUpperLevelText())"
            practicePlayButtonExstraLabel.text = text
            challengePlayButtonExstraLabel.text = text
        }
    }
    
    func playPracticeAction()
    {
        datactrl.fetchData(self.tags,fromLevel:Int(levelSlider.lowerValue),toLevel: Int(levelSlider.upperValue))
        datactrl.shuffleQuestions()
        datactrl.orderOnUsed()
        
        gametype = GameType.training
        self.performSegueWithIdentifier("segueFromMainMenuToPlay", sender: nil)
    }

    
    func practiceAction()
    {
        
        self.practicePlayButton.alpha = 0
        self.practicePlayButton.transform = CGAffineTransformScale(self.practicePlayButton.transform, 0.1, 0.1)
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
            self.removeAdsButton?.center = centerScreen
            self.removeAdsButton?.transform = CGAffineTransformScale(self.removeAdsButton!.transform, 0.1, 0.1)
            
            }, completion: { (value: Bool) in
                
                self.challengeUsersButton.alpha = 0
                self.practiceButton.alpha = 0
                self.resultsButton.alpha = 0
                self.removeAdsButton?.alpha = 0
                
                self.practicePlayButton.alpha = 1
                self.levelSlider.alpha = 1
                self.selectFilterTypeButton.alpha = 1
                
                self.borderSwitchLabel.alpha = 1
                self.borderSwitch.alpha = 1
                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.practicePlayButton.transform = CGAffineTransformIdentity
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


        self.challengePlayButton.alpha = 0
        self.challengePlayButton.transform = CGAffineTransformScale(self.challengePlayButton.transform, 0.1, 0.1)
        self.levelSlider.alpha = 0
        self.levelSlider.transform = CGAffineTransformScale(self.levelSlider.transform, 0.1, 0.1)
        //self.selectFilterTypeButton.alpha = 0
        //self.selectFilterTypeButton.transform = CGAffineTransformScale(self.selectFilterTypeButton.transform, 0.1, 0.1)
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
                
                self.challengePlayButton.alpha = 1
                self.levelSlider.alpha = 1
                //self.selectFilterTypeButton.alpha = 1
                
                self.borderSwitchLabel.alpha = 1
                self.borderSwitch.alpha = 1
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.challengePlayButton.transform = CGAffineTransformIdentity
                    self.levelSlider.transform = CGAffineTransformIdentity
                    //self.selectFilterTypeButton.transform = CGAffineTransformIdentity
                    self.borderSwitchLabel.transform = CGAffineTransformIdentity
                    self.borderSwitch.transform = CGAffineTransformIdentity
                    }, completion: { (value: Bool) in
                        
                })
        })
    }
    
    func playNewChallengeAction()
    {
        datactrl.fetchData(self.tags,fromLevel:Int(levelSlider.lowerValue),toLevel: Int(levelSlider.upperValue))
        datactrl.shuffleQuestions()
        datactrl.orderOnUsed()
        
        gametype = GameType.makingChallenge
        self.performSegueWithIdentifier("segueFromMainMenuToChallenge", sender: nil)
    }
    
    func pendingChallengesAction()
    {
        gametype = GameType.takingChallenge
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
            self.removeAdsButton?.transform = CGAffineTransformScale(self.removeAdsButton!.transform, 0.1, 0.1)
            
            }, completion: { (value: Bool) in
                
                self.challengeUsersButton.alpha = 0
                self.practiceButton.alpha = 0
                self.resultsButton.alpha = 0
                self.removeAdsButton?.alpha = 0
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
            //print("\(levelSlider.upperValue)")
            //svc.levelLow = Int(levelSlider.lowerValue)
            //svc.levelHigh = Int(levelSlider.upperValue)
            //svc.tags = self.tags
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
                self.removeAds()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case SKPaymentTransactionState.Restored:
                self.removeAds()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case SKPaymentTransactionState.Failed:
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func removeAds() {
        
        datactrl.adFreeValue = 1
        datactrl.saveGameData()
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "adFree")
        self.bannerView?.delegate = nil
        self.bannerView?.hidden = true
        bannerView?.frame.offsetInPlace(dx: 0, dy: bannerView!.frame.height)
    }

    var allowRotate = false
    override func shouldAutorotate() -> Bool {
        return allowRotate
    }
    
    func canRotate () -> Void{ }
    

}

