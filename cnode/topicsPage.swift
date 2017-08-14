import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import UIKit
class TopicsPage : UITableViewController{
    fileprivate var arr : Topics?
    let MyIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        Bar.foo(){
            self.arr = $0
            print(self.arr?.data?[0].top)
            self.tableView.reloadData()
        }
        tableView.register(Cell.self, forCellReuseIdentifier: MyIdentifier)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.arr?.data?[indexPath.row].id
        let t = TopicPage()
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
        a._avatar.kf.setImage(with:URL(string:(topic?.author?.avatar_url)!))
        return a
    }

    
}
import Kingfisher
import Cartography
fileprivate class Cell : UITableViewCell{
    var _title = UILabel()
    var _top = UILabel()
    var _avatar = UIImageView()
    var _author = UILabel()
    var _hot = UILabel()
    var _created = UILabel()
    var _lastReplied = UILabel()
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
            $1.left == $2.right  + 20
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
    class func foo(done:@escaping (_ t : Topics)->Void){
        let URL = "https://cnodejs.org/api/v1/topics?page=1"
        Alamofire.request(URL).responseObject { (response: DataResponse<Topics>) in
            let topics = response.result.value
            done(topics!)
        }
    }
}
fileprivate class Topics: Mappable {
    var success: Bool?
    var data : [Topic]?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        data <- map["data"]
    }
}
//content title last_reply_at good top reply_count visit_count create_at author{loginname,avatar_url}
class Author : Mappable{
    var loginname: String?
    var avatar_url: String?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        loginname <- map["loginname"]
        avatar_url <- map["avatar_url"]
    }
}
fileprivate class Topic: Mappable {
    var id: String?
    var author_id : String?
    var tab : String?
    var content : String?
    var title : String?
    var last_reply_at : String?
    var good : String?
    var top : Bool?
    var reply_count : Int?
    var visit_count : Int?
    var create_at : String?
    var author : Author?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        author_id <- map["author_id"]
        content <- map["content"]
        title <- map["title"]
        last_reply_at <- map["last_reply_at"]
        good <- map["good"]
        top <- map["top"]
        reply_count <- map["reply_count"]
        visit_count <- map["visit_count"]
        create_at <- map["create_at"]
        author <- map["author"]
        tab <- map["tab"]
    }
}
