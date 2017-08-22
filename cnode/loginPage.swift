class LoginPage: UIViewController {
    var _title = UITextView()
    var _add = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(_title)
        view.addSubview(_add)
        _add.setTitle("Add",for: .normal)
        _add.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        _title.backgroundColor = .blue
        _title.placeholder = "accesstoken  here..."
        _title.textColor = .white
        _title.setContentOffset(CGPoint.zero, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
        _add.backgroundColor = .blue
        constrain(self.view, _title,_add){
            
            $1.top == $0.top + 5
            $1.left == $0.left + 5
            $1.height == 40
            $1.right == $0.right - 5
            
            $2.top == $1.bottom + 5
            $2.left == $1.left
            $2.right == $0.right - 5
            $2.height == 30
        }
    }
    func buttonAction(_ sender:UIButton!){
        print(_title.text)
        Bar.foo (_title.text){
            let token = $0
            token.saveToKC()
            centerPage.popViewController(animated: true)
        }
    }
}
import UIKit
import Cartography
import Alamofire

fileprivate class Bar{
    class func foo(_ accesstoken :String, done:@escaping (_ token : AccessToken)->Void){
        let url = "https://cnodejs.org/api/v1/accesstoken"
        let params: [String: String] = [
            "accesstoken":accesstoken
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON{ response in
                //                print(response.request as Any)  // original URL request
                //                print(response.response as Any) // URL response
                print(response.result.value)   // result of response serialization
                let json = response.result.value as! [String:Any]
                print(json["success"])
                let s = json["success"]
                if s as! Bool {
                    done(AccessToken(accesstoken,json["loginname"] as! String,json["avatar_url"] as! String,json["id"] as! String))
                }else{
                    //tip error
                }
        }
    }
}
class AccessToken:NSObject,NSCoding{
    var accesstoken : String!
    var loginname : String!
    var avatar_url : String!
    var id : String!
    init(_ accesstoken : String,_ loginname : String,_ avatar_url : String ,_ id : String){
        self.accesstoken = accesstoken
        self.loginname = loginname
        self.avatar_url = avatar_url
        self.id = id
    }
    required convenience init?(coder decoder: NSCoder) {
        guard
            let accesstoken = decoder.decodeObject(forKey: "accesstoken") as? String,
            let loginname = decoder.decodeObject(forKey:"loginname") as? String,
            let avatar_url = decoder.decodeObject(forKey:"avatar_url") as? String,
            let id = decoder.decodeObject(forKey:"id") as? String
            else { return nil }
        
        self.init(accesstoken,loginname,avatar_url,id)
    }
    func encode(with coder: NSCoder) {
        coder.encode(self.accesstoken, forKey: "accesstoken")
        coder.encode(self.loginname, forKey: "loginname")
        coder.encode(self.avatar_url, forKey: "avatar_url")
        coder.encode(self.id, forKey: "id")
    }
    override public var description: String { return "{id:\(id),name:\(loginname)}" }
    func saveToKC(){
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        _ = Keychain.save(key: "AccessToken", data: data)
    }
    class func loadFromKC()-> AccessToken?{
        let data = Keychain.load(key: "AccessToken")
        return  NSKeyedUnarchiver.unarchiveObject(with: data!) as! AccessToken
    }
}
import UIKit
