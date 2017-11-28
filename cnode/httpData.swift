import Foundation
import Alamofire
func getJson(_ url : String ,done:@escaping (_ data : Data)->Void){
    let task = URLSession.shared.dataTask(with: URL(string:url)!) { (data, response, error) in
        if error != nil {
            print(error!)
        } else {
            if let usableData = data {
                done(usableData)
            }else{
                print("result is nil")
            }

        }
    }
    task.resume()
}
func postParameter(_ url : String,_ params:[String:String],done:@escaping (_ data : Data)-> Void){
    Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
        .responseData{ response in
            done(response.data!)
    }
}
func likes(_ loginname : String ,_ done:@escaping (_ t : [String])->Void){
    //        let id = "598f28a8e104026c52101860"
    let URL = "https://cnodejs.org/api/v1/topic_collect/\(loginname)"
    let params :[String:Any] = [:]
    //        getJson(URL){data  in
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
            if let _ = json["error_message"]{
                HUDError(json["error_message"] as! String)
            }
            HUDError("")
        }
    }
}
func like(_ id : String,_ token : String,done:@escaping (_ t : Any)->Void){
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
            done(1)
        }else{
            if let _ = json["error_message"] {
                HUDError(json["error_message"] as! String)
            }
            HUDError("")
        }
    }
}
func unlike(_ id : String,_ token : String,done:@escaping (_ t : Any)->Void){
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
            if let _ = json["error_message"] {
                HUDError(json["error_message"] as! String)
            }
            HUDError("")
        }
    }
}
func like(_ loginname : String ,done:@escaping (_ t : Any)->Void){
    let URL = "https://cnodejs.org/api/v1/topic_collect/\(loginname)"
    let params :[String:Any] = [:]
    Alamofire.request(URL, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON() {
        let result = $0.value
        let json = result as! [String:Any]
        let success = json["success"] as! Bool
        print(json)
        if success{
            HUDSuccess()
            done(result!)
        }else{
            if let _ = json["error_message"] {
                HUDError(json["error_message"] as! String)
            }
            HUDError("")
        }
    }
    
}
