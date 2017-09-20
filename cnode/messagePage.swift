import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import UIKit
class MessagePage : UITableViewController{
    fileprivate var arr : Message?
    fileprivate var items : [MessageItem]?=[]
    let MyIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefresh()
        scrollUp = up
        tableView.register(Cell.self, forCellReuseIdentifier: MyIdentifier)
        reload()
    }
    func ltap(){
        drawerController?.toggleLeftDrawerSide(animated: true, completion: nil)
    }
    func rtap(){
        //        drawerController?.toggleRightDrawerSide(animated: true, completion: nil)
        let t = CreatePage()
        self.navigationController?.pushViewController(t, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = items?[indexPath.row].topic?.id
        let t = TopicPage()
        t.id = id
        t.replyId = items?[indexPath.row].reply?.id
        self.navigationController?.pushViewController(t, animated: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arr != nil {
            return items!.count
        }else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    var scrollUp : ((_ cb : @escaping Callback)-> Void)?
    var scrollDown : ((_ cb : @escaping CallbackMore)-> Void)?
    var tab = "all"
    func reload(){
        Bar.likes(){
            self.arr = $0
            self.items! = []
            self.items! += ($0.data?.has_read_messages)!
            self.items! += ($0.data?.hasnot_read_messages)!
            self.tableView.reloadData()
        }
    }
    func up(_ cb : @escaping Callback){
        Bar.likes(){
            self.arr = $0
            self.items! += ($0.data?.has_read_messages)!
            self.items! += ($0.data?.hasnot_read_messages)!
            self.tableView.reloadData()
            cb()
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = tableView.dequeueReusableCell(withIdentifier: MyIdentifier) as! Cell
        let obj = items?[indexPath.row]
        a._title.text = obj?.topic?.title
        a._author.text = obj?.author?.loginname
        let read = (obj?.has_read)! ?"已读":"未读"
        let author = (obj?.author?.loginname)!
        let type =  obj?.type == "at" ?"@":"回复"
        let str = "\(read):\(author)\(type)了你"
        a._author.text = str
        return a
    }
    
    
}
import Kingfisher
import Cartography
fileprivate class Cell : UITableViewCell{
    var _title = UILabel()
    var _author = SizeLabel()
    override func layoutSubviews() {
        self.contentView.addSubview(_title)
        self.contentView.addSubview(_author)
//        self.contentView.addSubview(_type)
//        self.contentView.addSubview(_read)
        constrain(contentView,_title,_author){
            $1.left == $0.left  + 5
            $1.top  == $0.top + 5
            $1.width  == 300
            $1.height  == 40
            
            $2.left == $1.left
            $2.top  == $1.bottom + 5
            $2.width  == 300
            $2.height  == 20
//            
//            $3.left == $2.right  + 5
//            $3.top  == $2.top
//            $3.width  == 40
//            $3.height  == 20
//            
//            $4.left == $3.right  + 5
//            $4.top  == $2.top
//            $3.width  == 40
//            $3.height  == 20
        }
    }
}
fileprivate class Bar{
    class func likes(done:@escaping (_ done : Message)->Void){
        let token = AccessToken.loadFromKC()
        if let t = token?.accesstoken ,t != ""{
            Bar.likes(t, done)
        }
    }
    class func likes(_ token : String ,_ done:@escaping (_ t : Message)->Void){
        let URL = "https://cnodejs.org/api/v1/messages?accesstoken=\(token)"
        var params :[String:Any] = [:]
        Alamofire.request(URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseObject() {(response: DataResponse<Message>) in
            let message = response.result.value
            if (message?.success!)!{
                HUDSuccess()
                done(message!)
            }else{
                HUDError("")
            }
        }
    }
}
fileprivate class Message: Mappable {
    var success: Bool?
    var data : Data?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        data <- map["data"]
    }
}
fileprivate class Data: Mappable {
    var has_read_messages: [MessageItem]?
    var hasnot_read_messages :[MessageItem]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        has_read_messages <- map["has_read_messages"]
        hasnot_read_messages <- map["hasnot_read_messages"]
    }
}
//content title last_reply_at good top reply_count visit_count create_at author{loginname,avatar_url}
fileprivate class MessageItem : Mappable{
    var id: String?
    var type: String?
    var has_read: Bool?
    var author: Author?
    var topic: Topic?
    var reply: Reply?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        has_read <- map["has_read"]
        author <- map["author"]
        topic <- map["topic"]
        reply <- map["reply"]
    }
}
//content title last_reply_at good top reply_count visit_count create_at author{loginname,avatar_url}
fileprivate class Author : Mappable{
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
    var title : String?
    var last_reply_at : String?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        last_reply_at <- map["last_reply_at"]
    }
}
fileprivate class Reply: Mappable {
    var id: String?
    var content : String?
    var last_reply_at : String?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        content <- map["content"]
        last_reply_at <- map["last_reply_at"]
    }
}
//import GTMRefresh
extension MessagePage{
    func refresh() {
        if scrollUp != nil{
            scrollUp!(){
                self.tableView.endRefreshing(isSuccess: true)
            }
        }
    }
}
extension MessagePage {
    func loadMore() {
        if scrollDown != nil{
            scrollDown!(){
                self.tableView.endLoadMore(isNoMoreData: !$0)
            }
        }
    }
}
extension  MessagePage {
    func setupRefresh(){
        self.tableView.gtm_addRefreshHeaderView(){
            self.refresh()
        }
        self.tableView.gtm_addLoadMoreFooterView(){
            self.loadMore()
        }
    }
    func beginScrollUp(){
        refresh()
    }
    func endScrollUp(){
        self.tableView.endRefreshing(isSuccess: true)
    }
    func endScrollDown(_ hasMoreData : Bool = true){
        self.tableView.endLoadMore(isNoMoreData: !hasMoreData)
    }
    func beginRefresh(){
        self.refresh()
    }
}
