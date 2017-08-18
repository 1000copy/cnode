class AboutPage: UIViewController {
    var count = 0
    var avatar = UIImageView()
    var name = UILabel()
    var slogan = UILabel()
    var site = UILabel()
    var dismiss = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(name)
        view.addSubview(avatar)
        view.addSubview(slogan)
        view.addSubview(site)
        view.addSubview(dismiss)
        name.text =  "刘传君"
        slogan.text = "创过业、做过产品、一个爱读书，喜欢分享的程序员"
        slogan.numberOfLines = 0
        site.text = "http://lcj.sxl.cn"
        dismiss.setTitle("Close",for: .normal)
        dismiss.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        constrain(self.view, avatar, name,slogan,site){
            $1.top == $0.top + 100
            $1.centerX == $0.centerX
            $1.height == 38
            $1.width == 38
            
            $2.top == $1.bottom + 5
            $2.centerX == $1.centerX
            
            $3.top == $2.bottom + 5
            $3.centerX == $1.centerX
            $3.width == 100
            
            $4.top == $3.bottom + 5
            $4.centerX == $1.centerX
        }
        let url = "https://avatars2.githubusercontent.com/u/4485958?v=4&s=400"
        avatar.kf.setImage(with:URL(string:url))
    }
    func buttonAction(_ sender:UIButton!){
        centerPage.popViewController(animated: true)
    }
}
import UIKit
import Cartography
