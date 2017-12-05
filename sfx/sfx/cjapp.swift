
import UIKit
open class CJApp: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?
    public var mainPage : UIViewController?{
        get{
            return window?.rootViewController
        }
    }
    var centerPage_ : UIViewController?
    public var centerPage : UINavigationController{
        get{
            return centerPage_ as! UINavigationController
        }
    }
    public var homePage_ : UIViewController?
    public  var homePage : UIViewController?{
        get{
            return homePage_
        }
    }
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = queryMainPage()
        self.window?.makeKeyAndVisible()
        return onload()
    }
    open func onload()-> Bool{
        return true
    }
    open func queryMainPage()->UIViewController?{
        return DrawerBase(queryCenterPage()!,queryLeftPage()!,queryRightPage()!)
    }
    open func queryLeftPage()->UIViewController?{
        return nil
    }
    open func queryRightPage()->UIViewController?{
        return nil
    }
    open func queryCenterPage()->UIViewController?{
        centerPage_ = CenterPage()
        return centerPage_
    }
    open func queryHomePage()->UIViewController?{
        return nil
    }
    open func isDrawerApp()->Bool{
        return false
    }
    public static var shared:CJApp{
        get{
            return UIApplication.shared.delegate as! CJApp
        }
    }
    public func toggleLeftDrawer(){
        (mainPage as! DrawerBase).toggleLeftDrawerSide(animated: true, completion: nil)
    }
    public func toggleRightDrawer(){
        (mainPage as! DrawerBase).toggleRightDrawerSide(animated: true, completion: nil)
    }
}
class DrawerBase : DrawerController{
    init(_ center : UIViewController,_ left : UIViewController,_ right : UIViewController){
        super.init(centerViewController: center, leftDrawerViewController: left, rightDrawerViewController: right)
        //  此行代码，会导致 UIRefreshControll失效
        //        openDrawerGestureModeMask=OpenDrawerGestureMode.panningCenterView
        closeDrawerGestureModeMask=CloseDrawerGestureMode.all
        self.maximumLeftDrawerWidth = 150
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class CenterPage: UINavigationController {
    var count = 0
    var label : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //        self.pushViewController(TopicPage(), animated: true)
        let homePage_ = CJApp.shared.queryHomePage()
        self.pushViewController(homePage_!, animated: true)
    }
}

