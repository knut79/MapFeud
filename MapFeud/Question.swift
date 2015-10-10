import Foundation
import CoreData
import UIKit

class Question: NSManagedObject {
    
    @NSManaged var text: String
    @NSManaged var level:Int16
    @NSManaged var image:String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, text: String, level:Int, image:String) -> Question{
        let newitem = NSEntityDescription.insertNewObjectForEntityForName("Question", inManagedObjectContext: moc) as! Question
        newitem.text = text
        newitem.level = Int16(level)
        newitem.image = image
        return newitem
    }
}