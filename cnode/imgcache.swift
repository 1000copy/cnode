import UIKit
extension UIImageView{
    func setImage2(_ urlstr : String){
        ImageCache.shared.setImage(self,urlstr)
    }
}
class ImageCache{
    static let shared = ImageCache()
    func setImage(_ image : UIImageView,_ urlstr : String){
        let cacheData = self.hit(urlstr)
        if cacheData == nil{
            let url = URL(string: urlstr)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                if data != nil {
                    DispatchQueue.main.async {
                        image.image = UIImage(data: data!)
                        self.cache(urlstr,NSData(data:data!))
                    }
                }else{
                    print("error when visit image url:\(urlstr)")
                }
            }
        }else{
            image.image = UIImage(data: cacheData! as Data)
        }
    }
    let _innerCache = NSCache<NSString, NSData>()
    func hit(_ url : String)-> NSData?{
        let filename = MD5(url)
        if let cachedVersion = _innerCache.object(forKey:NSString(string: filename)) {
            // use the cached version
            print("hitted cache")
            return cachedVersion
        } else {
            // create it from scratch then store in the cache
            let path = getPath1(filename)
            print("try \(path)")
            let fileVersionData = NSData(contentsOfFile:path)
            if fileVersionData !=  nil {
                print("hitted file")
                self._innerCache.setObject(fileVersionData!, forKey:NSString(string: filename))
            }
            return fileVersionData
        }
    }
    func cache(_ url : String ,_ data : NSData){
        print("cached")
        let filename = MD5(url)
        self._innerCache.setObject(data, forKey:NSString(string: filename))
        let path = getPath(filename)
        do{
            print(path)
            let UUU = URL(string:path)!
            try data.write(to: UUU, options: .atomic)
            print("writed file")
        }catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    func getPath(_ filename : String)->String{
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return "file://\(documentDirectory)/\(filename)"
    }
    // fuck ,why NSData read func must no prefix "file://", and NSData write must have it ?
    // file://path/name  这个格式看着对，其实写入是会报错的，folder does not exists
    // file:///path/name 写入的时候，必须是这个格式！
    // /path/name        读入是，必须是这个格式，前一种是不可以的。艹。
    func getPath1(_ filename : String)->String{
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        return "\(documentDirectory)/\(filename)"
    }
 }
