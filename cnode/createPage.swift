class CreatePage: UIViewController {
    var _title = UITextView()
    var _content = UITextView()
    var _add = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(_title)
        view.addSubview(_content)
        view.addSubview(_add)
        _add.setTitle("Add",for: .normal)
        _add.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        _title.backgroundColor = .blue
        _title.placeholder = "title  here..."
        _title.textColor = .white
        _title.setContentOffset(CGPoint.zero, animated: true)
        // if not set , why start text from bottom ?
        self.navigationController?.navigationBar.isTranslucent = false
        _content.backgroundColor = .blue
        _content.textColor = .white
        _content.placeholder = "content here..."
        _add.backgroundColor = .blue
        constrain(self.view, _title,_content,_add){
            
            $1.top == $0.top + 5
            $1.left == $0.left + 5
            $1.height == 40
            $1.right == $0.right - 5
            
            $2.top == $1.bottom + 5
            $2.left == $1.left
            $2.right == $0.right - 5
            $2.height == 200
            
            $3.top == $2.bottom + 5
            $3.left == $1.left
            $3.right == $0.right - 5
            $3.height == 30
        }
    }
    func buttonAction(_ sender:UIButton!){
        print(_title.text)
        print(_content.text)
        Bar.foo (_title.text,_content.text){
            print("done")
        }
    }
}
import UIKit
import Cartography
import Alamofire
let accesstoken = "9c7d03d6-11ef-4637-b8d9-2be203140e5c"
fileprivate class Bar{
    class func foo(_ title : String ,_ content : String, done:@escaping ()->Void){
        let url = "https://cnodejs.org/api/v1/topics"
//        let params: [String: String] = [
//                "title":"abc",
//                "tab":"dev",
//                "content":"http%3a%2f%2flcj.sxl.cn",
//                "accesstoken":"9c7d03d6-11ef-4637-b8d9-2be203140e5c"
//            ]
        let params: [String: String] = [
            "title":title,
            "tab":"dev",
            "content":content,
            "accesstoken":accesstoken
        ]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseString { response in
//                print(response.request as Any)  // original URL request
//                print(response.response as Any) // URL response
                print(response.result.value)   // result of response serialization
                done()
        }
    }
}
import UIKit
