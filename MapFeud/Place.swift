import Foundation
import CoreData
import UIKit


enum PlaceType:Int
{
    //case info = 0
    case region = 0
    case city = 1
    case country = 2
}

class Place: NSManagedObject {
    
    @NSManaged var refId: String
    @NSManaged var name: String
    @NSManaged var type:Int16
    @NSManaged var hint1: String
    @NSManaged var hint2: String
    @NSManaged var points: NSSet
    @NSManaged var questions: NSSet
    @NSManaged var info:String
    @NSManaged var level:Int16
    @NSManaged var includePlaces:String
    @NSManaged var excludePlaces:String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, refId:String, type:String, level:Int, info:String, hint1:String, hint2:String, includePlaces:String, excludePlaces:String) -> Place{
        let newitem = NSEntityDescription.insertNewObjectForEntityForName("Place", inManagedObjectContext: moc) as! Place
        
        newitem.refId = refId == "" ? name : refId
        newitem.name = name
        
        newitem.type = 1
        newitem.info = info
        newitem.hint1 = hint1
        newitem.hint2 = hint2
        newitem.level = Int16(level)
        newitem.points = NSMutableSet()
        newitem.questions = NSMutableSet()
        
        newitem.includePlaces = includePlaces
        newitem.excludePlaces = excludePlaces
        return newitem
    }
    
    var sortedPoints:[LinePoint]
        {
        get{
            var sortedArray:[LinePoint] = []
            let sortDescriptor = NSSortDescriptor(key: "sort", ascending: true)
            sortedArray = self.points.sortedArrayUsingDescriptors([sortDescriptor]) as! [LinePoint]
            
            return sortedArray
        }
    }
}

extension Place {
    
    func addLinePoint(point:LinePoint) {
        
        var points: NSMutableSet
        points = self.mutableSetValueForKey("points")
        points.addObject(point)
    }
    
    func addQuestion(question:Question) {
        
        var questions: NSMutableSet
        questions = self.mutableSetValueForKey("questions")
        questions.addObject(question)
    }
}