import UIKit
import sfx
class TopicsPage : TJTablePage{
    fileprivate var arr : Topics?
    let MyIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollUp = up
        scrollDown = down
        self.navigationItem.title = "cnodejs-swift"
        tableView.register(Cell.self, forCellReuseIdentifier: MyIdentifier)
        var image = UIImage.init(icon: .emoji(.plus), size: CGSize(width: 20, height: 20))
        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.rightBarButtonItems =
            [
                UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(rtap))
        ]
        var image1 = UIImage.init(icon: .emoji(.menu), size: CGSize(width: 20, height: 20))
        image1 = image1.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image1, style: .plain, target: self, action: #selector(ltap))
        reload("all")
    }
    @objc func ltap(){
        
        CJApp.shared.toggleLeftDrawer()
    }
    @objc func rtap(){
        let t = CreatePage()
        self.navigationController?.pushViewController(t, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.arr?.data?[indexPath.row].id
        let t = TopicPage()
        t.id = id
        self.navigationController?.pushViewController(t, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr != nil {
            return (arr?.data!.count)!
        }else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    var tab = "all"
    func reload(_ tab : String){
        self.tab = tab
        Bar.foo(tab,1){
            self.arr = $0
            self.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: true)
        }
    }
    func up(_ cb : @escaping Callback){
        Bar.foo(tab,1){
            self.arr = $0
            self.tableView.reloadData()
            cb()
        }
        
    }
    func down(_ cb : @escaping CallbackMore){
        page += 1
        Bar.foo(tab,page){
            self.arr?.data! += $0.data!
            self.tableView.reloadData()
            cb(true)
        }
    }
    var page = 1
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = tableView.dequeueReusableCell(withIdentifier: MyIdentifier) as! Cell
        let topic = arr?.data![indexPath.row]
        a._title.text = topic?.title
        
        a._top.isHidden = !(topic?.top)!
        a._author.text = topic?.author?.loginname
        a._hot.text = "\((topic?.reply_count)!)/\((topic?.visit_count)!)"
        let d = date((topic?.create_at)!)!
        a._created.text = "创建于：\(d.getElapsedInterval())"
        let e = date((topic?.last_reply_at)!)!
        a._lastReplied.text = "\(e.getElapsedInterval())"
//        a._avatar.kf.setImage(with:URL(string:(topic?.author?.avatar_url)!))
        a._avatar.setImage2((topic?.author?.avatar_url)!)
        return a
    }

}
fileprivate class Cell : UITableViewCell{
    var _title = UILabel()
    var _top = UILabel()
    var _avatar = UIImageView()
    var _author = SizeLabel()
    var _hot = SizeLabel()
    var _created = SizeLabel()
    var _lastReplied = SizeLabel()
    override func layoutSubviews() {
        self.contentView.addSubview(_title)
        self.contentView.addSubview(_avatar)
        //        _avatar.image = UIImage.imageWithColor(.blue)
        _top.text = "置顶"
        _top.backgroundColor = .green
        self.contentView.addSubview(_top)
        self.contentView.addSubview(_author)
        self.contentView.addSubview(_hot)
        self.contentView.addSubview(_created)
        self.contentView.addSubview(_lastReplied)
        _hot.textAlignment = .right
        _lastReplied.textAlignment = .right
        //        _lastReplied.isHidden = true
       
        
        constrain(contentView,_title,_avatar,_top){
            $1.left == $2.right  + 5
            $1.top  == $0.top + 5
            $1.width  == 300
            $1.height  == 20
            
            $2.left == $0.left  + 5
            $2.top  == $3.bottom + 5
            $2.width  == 38
            $2.height  == 38
            
            $3.left == $0.left  + 5
            $3.top  == $0.top + 5
            $3.width  == 40
            $3.height  == 20
            
        }
        constrain(contentView,_avatar,_author){
            $2.left == $1.right  + 5
            $2.top  == $1.top
            $2.width  == 150
            $2.height  == 20
        }
        constrain(contentView,_avatar,_hot){
            $2.right == $0.right  -  5
            $2.top  == $1.top
            $2.width  == 200
            $2.height  == 20
        }
        constrain(contentView,_avatar,_created,_lastReplied){
            $2.left == $1.right  +  5
            $2.bottom  == $1.bottom
            $2.width  == 200
            $2.height  == 20
            
            $3.right == $0.right  -  5
            $3.bottom  == $1.bottom
            $3.width  == 200
            $3.height  == 20
        }
    }
}
fileprivate class Bar{
    class func foo(_ tab : String ,_ page : Int,done:@escaping (_ t : Topics)->Void){
        let url = "https://cnodejs.org/api/v1/topics?tab=\(tab)&page=\(page)"
        getJson(url){
            do{
            let decoder = JSONDecoder()
            let t = try decoder.decode(Topics.self, from: $0)
            done(t)
            }catch{
                print(error)
            }
        }
    }
}
// struct
fileprivate struct Topics: Codable {
    var success: Bool?
    var data : [TopicFF]?
}
fileprivate struct AuthorFF : Codable{
    var loginname: String?
    var avatar_url: String?
}
fileprivate struct TopicFF: Codable {
    var id: String?
    var author_id : String?
    var tab : String?
    var content : String?
    var title : String?
    var last_reply_at : String?
//    var good : Int?
    var good : Bool?
    var top : Bool?
    var reply_count : Int?
    var visit_count : Int?
    var create_at : String?
    var author : AuthorFF?
}
import sfx
