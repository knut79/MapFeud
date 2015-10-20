
import Foundation
import UIKit

class OkButton: UIButton {
    
    var innerView:UILabel!
    var numberOfHints:UILabel!
    var orgFrame:CGRect!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitle("🆗", forState: UIControlState.Normal)
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.masksToBounds = true

    }
    
    
    func isVisible() -> Bool
    {
        return self.frame == orgFrame
    }
    
    func hide(hide:Bool = true)
    {
        if hide 
        {
            if isVisible()
            {
                self.center = CGPointMake(UIScreen.mainScreen().bounds.maxX + self.frame.width, self.center.y)
            }
        }
        else
        {
            self.frame = self.orgFrame
        }
    }
}
