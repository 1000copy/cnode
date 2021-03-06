class ReplyPage: UIViewController {
    var _content = UITextView()
    var _add = UIButton()
    var topicId : String!
    var replyId : String!=""
    var replyName : String=""
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(_content)
        view.addSubview(_add)
        _add.setTitle("Add",for: .normal)
        _add.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        // if not set , why start text from bottom ?
        self.navigationController?.navigationBar.isTranslucent = false
        _content.backgroundColor = .blue
        _content.textColor = .white
        _content.placeholder = "content here..."
        _add.backgroundColor = .blue
        constrain(self.view,_content,_add){
            
            $1.top == $0.top + 5
            $1.left == $0.left + 5
            $1.height == 200
            $1.right == $0.right - 5
            
            $2.top == $1.bottom + 5
            $2.left == $1.left
            $2.right == $0.right - 5
            $2.height == 40
        }
        if replyId != "" {
            _content.text = "@\(replyName)："
            _content.placeholder = ""
        }
    }
    @objc func buttonAction(_ sender:UIButton!){
        print(_content.text)
        Bar.foo (topicId,replyId,_content.text){
            print("done")
        }
    }
}
import UIKit


fileprivate class Bar{
    class func foo(_ topicId : String ,_ replyId:String,_ content : String, done:@escaping ()->Void){
        let url = "https://cnodejs.org/api/v1/topic/\(topicId)/replies"
        let params: [String: String] = [
            "content":content,
            "reply_id":replyId,
            "accesstoken":accesstoken
        ]
        postParameter(url, params){data in
            done()
        }
    }
}
import UIKit
import sfx
