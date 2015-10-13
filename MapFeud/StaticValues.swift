//
//  StaticValues.swift
//  TimeIt
//
//  Created by knut on 18/07/15.
//  Copyright (c) 2015 knut. All rights reserved.
//

import Foundation
import UIKit


//City
//Where is the city %@ located
//, Mountain,
//Where is the mountain %@ located
//UnDefPlace
//else
//Where is %@ located"
//from %

//State
//Where is the state %@ located
//from %@ state border
//County
//Where is the county %@ located
//from %@ county border
//Lake
//from %@s waterfront
//
//UnDefWaterRegion
//Island
//Peninsula
//UnDefRegion
//Where is %@ located
//from %@

enum PlaceType: Int
{
    case City = 0,
    Mountain = 1,
    UnDefPlace = 2,
    State = 3,
    County = 4,
    Lake = 5,
    UnDefWaterRegion = 6,
    Island = 7,
    Peninsula = 8,
    UnDefRegion = 9
}