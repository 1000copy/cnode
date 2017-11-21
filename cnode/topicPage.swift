import Alamofire
//import AlamofireObjectMapper
//import ObjectMapper
import UIKit

//var lightReload = false
class TopicPage : UITableViewController,UIWebViewDelegate{
    var id: String?
    var replyId : String?
    fileprivate var result : ResultFF?
    var contentHeights : [IndexPath:CGFloat] = [:]
    override func viewDidLoad() {
        Bar.foo(id!){
            self.result = $0
            self.tableView.reloadData()
        }
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        tableView.register(ReplyCell.self, forCellReuseIdentifier: "ReplyCell")
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        refreshButtons()
    }
    func refreshButtons(){
        var image = UIImage.init(icon: .emoji(.link), size: CGSize(width: 20, height: 20))
        image = image.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        var image1 = UIImage.init(icon: .emoji(.arrowReply), size: CGSize(width: 20, height: 20))
        image1 = image1.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        var image3 = UIImage.init(icon: .emoji(.alien), size: CGSize(width: 20, height: 20))
        image3 = image3.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        Bar.likes(){
            if !$0.contains(self.id!){
                self.navigationItem.rightBarButtonItems =
                    [
                        UIBarButtonItem(image: image, style: .plain, target: self, action: Selector("like")),
                        UIBarButtonItem(image: image1, style: .plain, target: self, action: Selector("reply"))
                ]
            }else{
                self.navigationItem.rightBarButtonItems =
                    [
                        UIBarButtonItem(image: image3, style: .plain, target: self, action: Selector("unlike")),
                        UIBarButtonItem(image: image1, style: .plain, target: self, action: Selector("reply"))
                ]
            }
        }
    }
    var count : Int = 0
    func reply(){
        let ip = tableView.indexPathForSelectedRow
        let p = ReplyPage()
        p.topicId = id
        p.replyId = ""
        if let row = ip?.row,row > 0 {
            p.replyId = result?.data?.replies?[(ip?.row)! - 1].id
            p.replyName = (result?.data?.replies?[(ip?.row)! - 1].author?.loginname)!
        }
        centerPage.pushViewController(p, animated: true)
    }
    func like(){
        let token = AccessToken.loadFromKC()
        if let t = token?.accesstoken ,t != ""{
            Bar.like(id!,t){_ in
                self.refreshButtons()
            }
        }
    }
    func unlike(){
        let token = AccessToken.loadFromKC()
        if let t = token?.accesstoken ,t != ""{
            Bar.unlike(id!,t){_ in
                self.refreshButtons()
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result?.data?.replies?.count == nil {
            return 1
        }else{
            return (result?.data?.replies?.count)! + 1
        }
    }
    var webHeight : CGFloat?
    var heights : [IndexPath:CGFloat] = [:]
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            var aheight :CGFloat = 44.0
            if contentHeights[indexPath] != nil {
                aheight = contentHeights[indexPath]!
            }
            let titleheight:CGFloat = 12.0
            let avatarheight:CGFloat = 38.0
            let inset:CGFloat = 5.0
            let all:CGFloat = 4 * inset
            let h = all + titleheight  + avatarheight + aheight
            return CGFloat(h)
        }else{
            var aheight :CGFloat = 44.0
            if contentHeights[indexPath] != nil {
                aheight = contentHeights[indexPath]!
            }
            let titleheight:CGFloat = 12.0
            let inset:CGFloat = 5.0
            let all:CGFloat = 3 * inset
            // - 10 also can remove black line
            let h = all + titleheight  + aheight
            return CGFloat(h)
        }
    }
    let htmlhead =  "<!DOCTYPE html>" +
        "<html>" +
        "<head>" +
        "<meta charset=\"UTF-8\">" +
        "<style type=\"text/css\">" +
        "html{margin:0;padding:0;}" +
        "body {" +
        "margin: 0;" +
        "padding: 0;" +
        "}" +
        "img{" +
        "width: 90%;" +
        "height: auto;" +
        "display: block;" +
        "margin-left: auto;" +
        "margin-right: auto;" +
        "}" +
        "</style>" +
    "</head>"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let url = URL(string:"https://")
        if result?.data != nil {
            if indexPath.row == 0 {
                let a = tableView.dequeueReusableCell(withIdentifier: "Cell") as! Cell
                a._title.text = result?.data?.title
//                a._avatar.kf.setImage(with:URL(string:(result?.data?.author?.avatar_url)!))
                a._avatar.setImage2((result?.data?.author?.avatar_url)!)
                let topic = result?.data
                a._top.isHidden = !(topic?.top)!
                a._author.text = topic?.author?.loginname
                a._hot.text = "\((topic?.reply_count)!)/\((topic?.visit_count)!)"
                let d = date((topic?.create_at)!)!
                a._created.text = "创建于：\(d.getElapsedInterval())"
                let e = date((topic?.last_reply_at)!)!
                a._lastReplied.text = "\(e.getElapsedInterval())"
//                a._avatar.kf.setImage(with:URL(string:(topic?.author?.avatar_url)!))
                a._avatar.setImage2((topic?.author?.avatar_url)!)
                a._content.delegate = self
                a._content.indexPath = indexPath
                let html = htmlhead +  (topic?.content)!
                a._content.loadHTMLString(html, baseURL: url)
                return a
            }else{
                let a = tableView.dequeueReusableCell(withIdentifier: "ReplyCell")  as! ReplyCell
                let r = result?.data?.replies?[indexPath.row - 1]
//                a._avatar.kf.setImage(with:URL(string:(r?.author?.avatar_url)!))
                a._avatar.setImage2((r?.author?.avatar_url)!)
                let html = r?.content
                a._content.delegate = self
                a._content.indexPath = indexPath
                a._content.loadHTMLString((html)!, baseURL: url)
                if (r?.created != nil){
                    a._created.text = date((r?.created)!)?.getElapsedInterval()
                }
                a._author.text = r?.author?.loginname
                return a
            }
        }
        return UITableViewCell()
    }
    func getRowByReplyId(_ replyId : String)-> Int{
        var result = 0
        for reply in (self.result?.data?.replies)!{
            result += 1
            if reply.id == replyId{
                return result
            }
        }
        return result
    }
    func scrollToRow(){
        if let id = self.replyId{
            let row = getRowByReplyId(id)
            let ip = IndexPath(row: row, section: 0)
            tableView.scrollToRow(at: ip, at: .bottom, animated: true)
            scrolled = true
        }
    }
    var scrolled = false
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        let web = webView as! TJWeb
        if (contentHeights[web.indexPath] != nil)
        {
            // we already know height, no need to reload cell
            return
        }
        if web.scrollView.contentSize.height != 0 {
            contentHeights[web.indexPath] = web.scrollView.contentSize.height
//            print(contentHeights)
            tableView.reloadRows(at: [web.indexPath], with: .automatic)
        }
        let zoom = webView.bounds.size.width / webView.scrollView.contentSize.width
        webView.scrollView.setZoomScale(zoom, animated: true)
        if !scrolled{
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.scrollToRow()
            }
        }
    }
}
class TJWeb : UIWebView,UIWebViewDelegate{
    var indexPath : IndexPath!
    override func layoutSubviews() {
        //Black line appearing at bottom of UIWebView. How to remove?
        isOpaque = false
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
}
//import Kingfisher

extension UITableViewCell {
    var tableView: UITableView? {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        return view as? UITableView
    }
}
fileprivate class ReplyCell : UITableViewCell,UIWebViewDelegate{
    var _content = TJWeb()
    var _author  = SizeLabel()
    var _created = SizeLabel()
    var _avatar  = UIImageView()
    var isNotified = false
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 1
        let size = CGSize(width: webView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        let newSize = webView.sizeThatFits(size)
        webView.frame.size.height = newSize.height
    }
    fileprivate override func layoutSubviews() {
        
         self.contentView.addSubview(_content)
        self.contentView.addSubview(_author)
        self.contentView.addSubview(_created)
        self.contentView.addSubview(_avatar)
        _created.textAlignment = .right
        _content.isUserInteractionEnabled = false
        _content.scrollView.contentInset = UIEdgeInsets.zero;
        constrain(contentView,_avatar,_created,_content,_author){
            $1.left == $0.left + 5
            $1.top == $0.top + 5
            $1.height == 38
            $1.width == 38
            
            $2.top == $1.top
            $2.right == $0.right - 5
            
            $3.top == $4.bottom
            $3.left == $1.right
            $3.right == $0.right
            $3.bottom == $0.bottom
            
            $4.left == $1.right + 5
            $4.top == $1.top
            
        }
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
    var _content = TJWeb()
    var isNotified = false
    override func layoutSubviews() {
        
        self.contentView.addSubview(_title)
        self.contentView.addSubview(_avatar)
        _top.text = "置顶"
        _top.backgroundColor = .green
        self.contentView.addSubview(_top)
        self.contentView.addSubview(_author)
        self.contentView.addSubview(_hot)
        self.contentView.addSubview(_created)
        self.contentView.addSubview(_lastReplied)
        self.contentView.addSubview(_content)
        _hot.textAlignment = .right
        _lastReplied.textAlignment = .right
        _content.isUserInteractionEnabled = false
        _content.scrollView.contentInset = UIEdgeInsets.zero;
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
        constrain(contentView,_avatar,_content){
            $2.left == $1.left
            $2.top  == $1.bottom + 5
            $2.width  == $0.width
            $2.bottom  == $0.bottom
        }
    }
}
fileprivate class Bar{
//    class func foo(_ id : String,done:@escaping (_ t : Result)->Void){
////        let id = "599afc79ebaa046923a82644"
//        let URL = "https://cnodejs.org/api/v1/topic/\(id)"
//        var params :[String:Any] = [:]
//        params["mdrender"] = true
//        Alamofire.request(URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseObject { (response: DataResponse<Result>) in
//            let topics = response.result.value
//            print(topics)
//            done(topics!)
//        }
//    }
    class func foo(_ id : String,done:@escaping (_ t : ResultFF)->Void){
        //        let id = "599afc79ebaa046923a82644"
        let URL = "https://cnodejs.org/api/v1/topic/\(id)"
        var params :[String:Any] = [:]
        params["mdrender"] = true
        Alamofire.request(URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            let topics = response.data
            let decoder = JSONDecoder()
            let topics1 = try! decoder.decode(ResultFF.self, from: topics!)
            print(topics1)
            done(topics1)
        }
    }
    class func likes(_ loginname : String ,_ done:@escaping (_ t : [String])->Void){
        //        let id = "598f28a8e104026c52101860"
        let URL = "https://cnodejs.org/api/v1/topic_collect/\(loginname)"
        var params :[String:Any] = [:]
        Alamofire.request(URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON() {
            let result = $0.value
            let json = result as! [String:Any]
            let success = json["success"] as! Bool
            print(json)
            if success{
//                HUDSuccess()
                var topicIds :[String] = []
                let data = json["data"] as! [[String:Any]]
                for  item in data {
                    let id = item["id"] as! String
                    topicIds.append(id)
                }
                print(topicIds)
                done(topicIds)
            }else{
                if let error = json["error_message"] ,error != nil{
                    HUDError(json["error_message"] as! String)
                }
                HUDError("")
            }
        }
    }
    class func likes(done:@escaping (_ done : [String])->Void){
        let token = AccessToken.loadFromKC()
        if let t = token?.accesstoken ,t != ""{
            Bar.likes((token?.loginname)!, done)
        }
    }
    class func like(_ id : String,_ token : String,done:@escaping (_ t : Any)->Void){
        //        let id = "598f28a8e104026c52101860"
        let URL = "https://cnodejs.org/api/v1/topic_collect/collect"
        var params :[String:Any] = [:]
        params["accesstoken"] = token
        params["topic_id"] = id
        Alamofire.request(URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON() {
            let result = $0.value
            let json = result as! [String:Any]
            let success = json["success"] as! Bool
            print(json)
            if success{
                HUDSuccess()
                var topicIds :[String] = []
//                let data = json["data"] as! [[String:Any]]
//                for  item in data {
//                    let id = item["id"] as! String
//                    topicIds.append(id)
//                }
//                print(topicIds)
                done(1)
            }else{
                if let error = json["error_message"] ,error != nil{
                    HUDError(json["error_message"] as! String)
                }
                HUDError("")
            }
        }
    }
    class func unlike(_ id : String,_ token : String,done:@escaping (_ t : Any)->Void){
        //        let id = "598f28a8e104026c52101860"
        let URL = "https://cnodejs.org/api/v1/topic_collect/de_collect"
        var params :[String:Any] = [:]
        params["accesstoken"] = token
        params["topic_id"] = id
        Alamofire.request(URL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON() {
            let result = $0.value
            let json = result as! [String:Any]
            let success = json["success"] as! Bool
            print(json)
            if success{
                HUDSuccess()
                done(1)
            }else{
                if let error = json["error_message"] ,error != nil{
                    HUDError(json["error_message"] as! String)
                }
                HUDError("")
            }
        }
    }
    class func like(_ loginname : String ,done:@escaping (_ t : Any)->Void){
        let URL = "https://cnodejs.org/api/v1/topic_collect/\(loginname)"
        var params :[String:Any] = [:]
        Alamofire.request(URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON() {
            let result = $0.value
            let json = result as! [String:Any]
            let success = json["success"] as! Bool
            print(json)
            if success{
                HUDSuccess()
                done(result!)
            }else{
                if let error = json["error_message"] ,error != nil{
                    HUDError(json["error_message"] as! String)
                }
                HUDError("")
            }
        }

    }
//
}


public func HUDSuccess(_ status:String!="") {
    //    V2ProgressHUD.success(status)
    HUD.hide()
    HUD.flash(.success)
}
public func HUDError(_ status:String!) {
    //    V2ProgressHUD.success(status)
    HUD.hide()
    HUD.flash(.error)
}
fileprivate struct ResultFF: Codable {
    var success: Bool?
    var data : DataFF?
}
fileprivate struct AuthorFF : Codable{
    var loginname: String?
    var avatar_url: String?
}

fileprivate struct DataFF : Codable{
    var content : String?
    var title : String?
    var replies : [ReplyFF]?
    fileprivate var author : AuthorFF?
    var author_id : String?
    var tab : String?
    var last_reply_at : String?
    var good : Int?
    var top : Bool?
    var reply_count : Int?
    var visit_count : Int?
    var create_at : String?
}

fileprivate struct ReplyFF: Codable {
    var id: String?
    var content : String?
    var title : String?
    fileprivate var author : AuthorFF?
    var created : String?
}

