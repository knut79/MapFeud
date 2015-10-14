//
//  CoordinateHelper.swift
//  MapFeud
//
//  Created by knut on 13/10/15.
//  Copyright © 2015 knut. All rights reserved.
//

import Foundation
import UIKit

class CoordinateHelper {
    
    var includedRegions:[[LinePoint]] = []
    var excludedRegions:[[LinePoint]] = []
    init(includedRegions:[[LinePoint]], excludedRegions:[[LinePoint]])
    {
        self.includedRegions = includedRegions
        self.excludedRegions = excludedRegions
    }
    
    //Returns nil if correct answer
    func getNearestPoint(point:CGPoint) -> CGPoint?
    {
        //check if point is within any of the polygons
        //..... get nearest border point
        //else .. check if point within exluded area
        //......get nearest border point
        
        var nearestPoint:CGPoint?
        var cgPointIncluded:[CGPoint] = []
        for item in includedRegions[0]
        {
            let linePoint = item as LinePoint
            cgPointIncluded.append(CGPointMake(CGFloat(linePoint.x), CGFloat(linePoint.y)))
        }
        let inside = point.isInsidePolygon(cgPointIncluded)
        
        
        if inside == false
        {
            nearestPoint = point.nearestPointInPolygon(cgPointIncluded)
        }
        else
        {
            //check if point inside excluded region
            var cgPointExcluded:[CGPoint] = []
            for item in excludedRegions[0]
            {
                let linePoint = item as LinePoint
                cgPointExcluded.append(CGPointMake(CGFloat(linePoint.x), CGFloat(linePoint.y)))
            }
            let insideExcluded = point.isInsidePolygon(cgPointExcluded)
            if insideExcluded
            {
                nearestPoint = point.nearestPointInPolygon(cgPointExcluded)
            }
        }
        
        //check outside of map on both sides
        if let np = nearestPoint
        {
            let leftNearestPoint = CGPointMake(np.x - GlobalConstants.constMapWidth, np.y)
            let rightNearestPoint = CGPointMake(np.x + GlobalConstants.constMapWidth, np.y)
            let orgDistance = point.distanceFromCGPoints(np)
            let distanceLeftside = point.distanceFromCGPoints(leftNearestPoint)
            let distanceRightside = point.distanceFromCGPoints(rightNearestPoint)
            if orgDistance > distanceLeftside
            {
                let leftPoint = CGPointMake(point.x + GlobalConstants.constMapWidth, point.y)
                nearestPoint = leftPoint.nearestPointInPolygon(cgPointIncluded)
                nearestPoint = CGPointMake(nearestPoint!.x - GlobalConstants.constMapWidth, nearestPoint!.y)
                //nearestPoint = leftPoint
            }
            else if orgDistance > distanceRightside // ok
            {
                let rightPoint = CGPointMake(point.x - GlobalConstants.constMapWidth, point.y)
                nearestPoint = rightPoint.nearestPointInPolygon(cgPointIncluded)
                nearestPoint = CGPointMake(nearestPoint!.x + GlobalConstants.constMapWidth, nearestPoint!.y)
                //nearestPoint = rightPoint
            }
        }
        return nearestPoint
    }
    
}

extension CGPoint{
    
    func nearestPointInPolygon(vertices:[CGPoint]) -> CGPoint
    {
        var nearestPoint:CGPoint?
        var nearestDistance:CGFloat = CGFloat.max
        for var i = 0; i < vertices.count; i++
        {
            let tempNearestDistance = self.distanceFromCGPoints(vertices[i])
            if tempNearestDistance < nearestDistance
            {
                nearestDistance = tempNearestDistance
                nearestPoint = vertices[i]
            }
        }
        return nearestPoint!
    }
    
    func distanceFromCGPoints(p:CGPoint)->CGFloat{
        return sqrt(pow(x - p.x,2)+pow(y - p.y,2));
    }
    
    func isInsidePolygon(vertices:[CGPoint]) -> Bool {
        var i = 0, j = 0, c = false, vi:CGPoint, vj:CGPoint
        for (i = 0, j = vertices.count-1; i < vertices.count; j = i++) {
            vi = vertices[i]
            vj = vertices[j]
            let par1 = vi.y > y
            let par2 = vj.y > y
            let par3 = vj.x - vi.x
            let par4 = y - vi.y
            let par5 = vj.y - vi.y
            if ( ((par1) != (par2)) &&
                (x < (par3) * (par4) / (par5) + vi.x) ) {
                    c = !c;
            }
        }
        return c
    }
    /*
    func distanceFromCGPoints(a:CGPoint,b:CGPoint)->CGFloat{
        return sqrt(pow(a.x-b.x,2)+pow(a.y-b.y,2));
    }
    */
}
