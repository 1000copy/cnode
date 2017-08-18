import UIKit
import DrawerController
var drawerController : DrawerPage!
var homePage : TopicsPage!
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        drawerController = DrawerPage()
        self.window!.rootViewController = drawerController
//        self.window!.rootViewController = CenterPage()
//        self.window!.rootViewController = LeftPage()
        self.window?.makeKeyAndVisible()
        return true
    }
}
class DrawerPage : DrawerBase{
    init(){
        super.init(CenterPage(),LeftPage(),RightPage())
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
class DrawerBase : DrawerController{
    init(_ center : UIViewController,_ left : UIViewController,_ right : UIViewController){
        super.init(centerViewController: center, leftDrawerViewController: left, rightDrawerViewController: right)
        openDrawerGestureModeMask=OpenDrawerGestureMode.panningCenterView
        closeDrawerGestureModeMask=CloseDrawerGestureMode.all;
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
        homePage = TopicsPage()
        self.pushViewController(homePage, animated: true)
    }
    func addTapped(){
        
    }
}
class RightPage: UIViewController {
    var count = 0
    var label : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        label   = UILabel()
        label.frame = CGRect(x: 100, y: 100, width: 120, height: 50)
        label.text =  "Right"
        view.addSubview(label)
        let button   = UIButton(type: .system)
        button.frame = CGRect(x: 120, y: 150, width: 120, height: 50)
        button.setTitle("Close",for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    func buttonAction(_ sender:UIButton!){
        drawerController?.toggleRightDrawerSide(animated: true, completion: nil)
    }
}
