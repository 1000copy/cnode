class LeftPage: UIViewController {
    var count = 0
    var top = Top()
    fileprivate var table = Table()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(top)
        view.addSubview(table)
        constrain(view,top,table){
            $1.top == $0.top
            $1.left == $0.left
            $1.right == $0.right
            $1.height == 150
            
            $2.top == $1.bottom
            $2.left == $0.left
            $2.right == $0.right
            $2.bottom == $0.bottom
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        top.refill()
    }
}
class Avatar : UIImageView{
    
}
class Top: UIView{
    var label : UILabel!
    var avatar = Avatar()
    var button = UIButton(type: .system)
    override func layoutSubviews() {
        self.backgroundColor = .white
        label   = UILabel()
        label.text =  ""
        self.addSubview(label)
        button.setTitle("登录",for: .normal)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        self.addSubview(button)
        self.addSubview(avatar)
        label.textAlignment = .center
        constrain(self,avatar,label,button){
            $1.center == $0.center
            $1.width == 38
            $1.height == 38
            
            $2.top == $1.bottom + 2
            $2.centerX == $0.centerX
            $2.height == 20
            
            $3.top == $2.bottom + 2
            $3.centerX == $0.centerX
            $3.height == 20
            
        }
        refill()
    }
    var refilled = false
    func refill(){
        if !refilled{
            let t = AccessToken.loadFromKC()
            if t != nil ,t?.accesstoken != "" {
                avatar.setImage2((t?.avatar_url!)!)
                label.text = t?.loginname!
                button.setTitle("登出",for: .normal)
            }else{
                let url = "https://avatars3.githubusercontent.com/u/20022617?v=4&s=120"
                avatar.setImage2(url)
            }
            refilled = true
        }
    }
    
    func buttonAction(_ sender:UIButton!){
        if button.titleLabel?.text == "登出"{
            let token = AccessToken("","","","")
            token.saveToKC()
            label.text = ""
            avatar.image = nil
             button.setTitle("登录",for: .normal)
        }else{
            centerPage.pushViewController(LoginPage(), animated: true)
        }
        drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)
    }
}

class Item{
    var emoji : EmojiType!
    var title : String!
    var tab : String!
    init(_ emoji : EmojiType,_ title : String,_ tab : String){
        self.emoji = emoji
        self.title = title
        self.tab = tab
    }
}
fileprivate  class Table: UITableView,UITableViewDataSource,UITableViewDelegate{
    let arr : [Item] = [
            Item(EmojiType.home,"全部","all"),
            Item(EmojiType.enter,"问答","ask"),
            Item(EmojiType.bookmark,"招聘","job"),
            Item(EmojiType.book,"精华","good"),
            Item(EmojiType.previousPage,"分享","share"),
            Item(EmojiType.starOfDavid,"收藏",""),
//            Item(EmojiType.gear,"设置",""),
            Item(EmojiType.anchor,"消息",""),
            Item(EmojiType.shield,"关于",""),
    ]
    let MyIdentifier = "cell"
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame:frame,style:style)
        self.dataSource = self
        self.delegate = self
        self.register(Cell.self, forCellReuseIdentifier: MyIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = tableView.dequeueReusableCell(withIdentifier: MyIdentifier) as! Cell
        a.label.text = String(arr[indexPath.row].title)
        a.icon.image = UIImage.init(icon: .emoji(arr[indexPath.row].emoji), size: CGSize(width: 35, height: 35), textColor: .black,
                                    backgroundColor: .white)
        a.icon.image = a.icon.image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        return a
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let tab = arr[indexPath.row].tab
        if tab != ""{
            homePage.reload(tab!)
        }else{
            if arr[indexPath.row].title == "关于"{
                centerPage.pushViewController(AboutPage(), animated: true)
            }else if arr[indexPath.row].title == "设置"{
                centerPage.pushViewController(SettingPage(), animated: true)
            }else if arr[indexPath.row].title == "消息"{
                centerPage.pushViewController(MessagePage(), animated: true)
            }else if arr[indexPath.row].title == "收藏"{
                centerPage.pushViewController(CollectPage(), animated: true)
            }
        }
        drawerController.toggleLeftDrawerSide(animated: true, completion: nil)
    }
}
fileprivate class Cell : UITableViewCell{
    var label  = UILabel()
    var icon  = UIImageView()
    override func layoutSubviews() {
        self.contentView.addSubview(label)
        self.contentView.addSubview(icon)
        constrain(contentView, icon, label){
            $1.left == $0.left + 5
            $1.top == $0.top + 5
            $1.height == 20
            $1.width == 20
            
            $2.left == $1.right + 5
            $2.top == $1.top
            $2.height == 20
            $2.width == 200
        }
    }
}

import UIKit

