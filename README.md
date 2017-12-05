
## cnode库

最初只是开发了一个cnodejs的客户端，随后，我把这个客户端的可共享的代码分离出来，作为一个框架。
此框架可以简化swift应用开发，并且内置了若干组件。

## 使用方法

    pod init

然后贴入如下内容
    
    pod 'cnode',:git=> 'https://github.com/1000copy/cnode.git'

随后更新代码库：

    pod install --verbose --no-repo-update

## 替换代码

你的AppDelegate为：


    import UIKit
    import cnode
    @UIApplicationMain
    class App: CJApp{
        override func queryMainPage()->UIViewController?{
            let v = UIViewController()
            v.view.backgroundColor = .blue
            return v
        }
        override func isDrawerApp()->Bool{
            return false
        }
    }

-----

以下为老的readme

## cnodejs-swift 发布

全部使用 Swift 3.0 开发，IDE版本为8.2.1

### 截图

![首页](img/1.png)
![主题](img/2.png)
![左抽屉](img/3.png)

### 鸣谢


	Alamofire
    ObjectMapper 
    AlamofireObjectMapper
    Cartography
    Kingfisher 
    GTMRefresh
    DrawerController
    SwiftIcons
    PKHUD

### 安装

over-the-air in github.io

### 项目主页

https://github.com/1000copy/cnode

### 问题反馈

https://github.com/1000copy/cnode/issues

### 特别说明

我在学习swift，想要做一个cnode.js的客户端。我看到

	https://github.com/klesh/cnodejs-swift

想要拿现成的，但是这个仓库不支持swift3.0，并且我发布了issue也没有人理睬，干脆自己做算了
