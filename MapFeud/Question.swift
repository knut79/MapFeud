import Foundation
import CoreData
import UIKit

class Question: NSManagedObject {
    
    @NSManaged var text: String
    @NSManaged var level:Int16
    @NSManaged var image:String
    @NSManaged var answerTemplate:String
    @NSManaged var used:Int32
    @NSManaged var place:Place
    @NSManaged var tags:String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, text: String, level:Int, image:String, answerTemplate:String, tags:String) -> Question{
        let newitem = NSEntityDescription.insertNewObjectForEntityForName("Question", inManagedObjectContext: moc) as! Question
        newitem.text = text
        newitem.level = Int16(level)
        newitem.image = image
        newitem.answerTemplate = answerTemplate
        newitem.used = 0
        newitem.tags = tags
        return newitem
    }
}