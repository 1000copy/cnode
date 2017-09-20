class TJTablePage : UITableViewController{
    var scrollUp : ((_ cb : @escaping Callback)-> Void)?
    var scrollDown : ((_ cb : @escaping CallbackMore)-> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefresh()
    }
    
}
typealias Callback = ()-> Void
typealias CallbackMore = (_ b : Bool)-> Void
fileprivate extension  TJTablePage {
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

extension TJTablePage{
    func refresh() {
        if scrollUp != nil{
            scrollUp!(){
                self.tableView.endRefreshing(isSuccess: true)
            }
        }
    }
}
extension TJTablePage {
    func loadMore() {
        if scrollDown != nil{
            scrollDown!(){
                self.tableView.endLoadMore(isNoMoreData: !$0)
            }
        }
    }
}
import UIKit
