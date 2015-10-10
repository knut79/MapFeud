//
//  ViewController.swift
//  MapFeud
//
//  Created by knut on 05/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var datactrl:DataHandler!
    var map:MapScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        map = MapScrollView(frame: UIScreen.mainScreen().bounds)
        
        datactrl = (UIApplication.sharedApplication().delegate as! AppDelegate).datactrl
        
        self.view.addSubview(map)
        
        populateDataIfNeeded()
    }
    
    func populateDataIfNeeded()
    {
        if Int(datactrl.dataPopulatedValue as! NSNumber) <= 0
        {
            
            DataHandler().populateData({ () in
                
                
                //self.loadingDataView.alpha = 0
                //self.loadingDataView.layer.removeAllAnimations()
                self.afterPopulateData()
            })
            
            //loadingDataView?.frame =  CGRectMake(50, 50, 200, 50)
        }
        else
        {
            afterPopulateData()
        }
    }
    
    func afterPopulateData()
    {
        datactrl.fetchData()
        let southAfricaTestExcluded = datactrl.fetchPlace("South Africa")
        //map.drawPlace(datactrl.placeItems[0])
        map.drawPlace(southAfricaTestExcluded!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

