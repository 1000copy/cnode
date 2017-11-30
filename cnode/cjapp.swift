
import UIKit
class CJApp: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainPage : UIViewController?{
        get{
            return window?.rootViewController
        }
    }
    var centerPage_ : UIViewController?
    var centerPage : UINavigationController{
        get{
            return centerPage_ as! UINavigationController
        }
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if isDrawerApp(){
            window?.rootViewController = queryMainPage()
        }
        self.window?.makeKeyAndVisible()
        return onload()
    }
    func onload()-> Bool{
        return true
    }
    func queryMainPage()->UIViewController?{
        return DrawerBase(queryCenterPage()!,queryLeftPage()!,queryRightPage()!)
    }
    func queryLeftPage()->UIViewController?{
        return nil
    }
    func queryRightPage()->UIViewController?{
        return nil
    }
    func queryCenterPage()->UIViewController?{
        centerPage_ = CenterPage()
        return centerPage_
    }
    func queryHomePage()->UIViewController?{
        return nil
    }
    func isDrawerApp()->Bool{
        return false
    }
    static var shared:CJApp{
        get{
            return UIApplication.shared.delegate as! CJApp
        }
    }
    func toggleLeftDrawer(){
        (mainPage as! DrawerBase).toggleLeftDrawerSide(animated: true, completion: nil)
    }
    func toggleRightDrawer(){
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
        homePage = CJApp.shared.queryHomePage() as! TopicsPage
        self.pushViewController(homePage, animated: true)
    }
}
