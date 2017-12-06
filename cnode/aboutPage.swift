class AboutPage: UIViewController {
    var count = 0
    var avatar = UIImageView()
    var name = UILabel()
    var slogan = UITextView()
    var site = URLLabel()
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
//        slogan.numberOfLines = 0
        slogan.isEditable = false
        slogan.isUserInteractionEnabled = false

        site.text = "https://lcj.sxl.cn/"
        site.textAlignment = .center
        dismiss.setTitle("Close",for: .normal)
        dismiss.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        constrain(self.view, avatar, name,slogan,site){
            $1.top == $0.top + 100
            $1.centerX == $0.centerX
            $1.height == 38
            $1.width == 38
            
            $2.top == $1.bottom + 15
            $2.centerX == $1.centerX
            
            $3.top == $2.bottom + 5
            $3.centerX == $1.centerX
            $3.width == 100
            $3.height == 100
            
            $4.top == $3.bottom + 5
            $4.centerX == $1.centerX
            $4.width == 200
            $4.height == 30
        }
        let url = "https://avatars2.githubusercontent.com/u/4485958?v=4&s=400"
//        avatar.kf.setImage(with:URL(string:url))
        avatar.setImage2(url)
        //
        let homepage : String = "https://lcj.sxl.cn"
       
        
//        site.attributedText = getAttributedText(homepage)
        site.url = homepage
        site.onCharacterTapped = { label, characterIndex in
            let url = URL(string: homepage)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @objc func buttonAction(_ sender:UIButton!){
        CJApp.shared.centerPage.popViewController(animated: true)
    }
}
import sfx
import UIKit
