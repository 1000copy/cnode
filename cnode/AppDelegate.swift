
import UIKit
//var homePage : TopicsPage!
@UIApplicationMain
class App: CJApp{
    override func queryHomePage()->UIViewController?{
        homePage_ = TopicsPage()
        return homePage_
    }
    override func queryLeftPage()->UIViewController?{
        return LeftPage()
    }
    override func queryRightPage()->UIViewController?{
        return RightPage()
    }
    override func isDrawerApp()->Bool{
        return true
    }
}


