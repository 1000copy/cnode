class SettingPage: UIViewController {
    var count = 0
    var label : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        label   = UILabel()
        label.frame = CGRect(x: 100, y: 100, width: 120, height: 50)
        label.text =  "设置"
        view.addSubview(label)
        let button   = UIButton(type: .system)
        button.frame = CGRect(x: 120, y: 150, width: 120, height: 50)
        button.setTitle("Close",for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    func buttonAction(_ sender:UIButton!){
        CJApp.shared.toggleRightDrawer()
    }
}
import UIKit
