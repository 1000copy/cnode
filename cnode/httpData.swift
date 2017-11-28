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

//func getJson(_ url : String ,done:@escaping (_ data : Data)->Void){
//    let params :[String:Any] = [:]
//    Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON() {response in
//        if let usableData = response.data {
//            done(usableData)
//        }else{
//            print("result is nil")
//        }
//    }
//}

