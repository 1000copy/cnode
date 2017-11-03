class CreatePage: UIViewController ,UIPickerViewDataSource,UIPickerViewDelegate{
    var _title = UITextView()
    var _content = UITextView()
    var _add = UIButton()
    var _picker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(_title)
        view.addSubview(_content)
        view.addSubview(_add)
        view.addSubview(_picker)
//        p.frame =  CGRect(x: 10,y: 50,width: 320,height: 200)
        _picker.dataSource = self
        _picker.delegate = self
        
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
        constrain(self.view, _title,_content,_picker,_add){
            
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
            $3.height == 100
            
            $4.top == $3.bottom + 5
            $4.left == $1.left
            $4.right == $0.right - 5
            $4.height == 30
        }
    }
    let a = ["客户端测试","分享","问答","招聘"]
    let b = ["dev","share","ask","job"]
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return a.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return a[row]
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    func buttonAction(_ sender:UIButton!){
        print(_title.text)
        print(_content.text)
        let tab = b[self._picker.selectedRow(inComponent: 0)]
        if !isEmpty(tab) && !isEmpty(_title.text) && !isEmpty(_content.text){
            Bar.foo ("dev",_title.text,_content.text){
                print("done")
            }
        }else{
            HUD.flash(.label("标题和内容不可以为空"), onView: nil,delay:2)
        }
    }
    func isEmpty(_ str : String)->Bool{
        return str != nil && str != ""
    }
}
import UIKit

import Alamofire
let accesstoken = "9c7d03d6-11ef-4637-b8d9-2be203140e5c"
fileprivate class Bar{
    class func foo(_ tab : String ,_ title : String ,_ content : String, done:@escaping ()->Void){
        let url = "https://cnodejs.org/api/v1/topics"
//        let params: [String: String] = [
//                "title":"abc",
//                "tab":"dev",
//                "content":"http%3a%2f%2flcj.sxl.cn",
//                "accesstoken":"9c7d03d6-11ef-4637-b8d9-2be203140e5c"
//            ]
        let params: [String: String] = [
            "title":title,
            "tab":tab,
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
