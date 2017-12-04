public class DefaultGTMRefreshHeader: GTMRefreshHeader, SubGTMRefreshHeaderProtocol {
//    var pullDownToRefresh = GTMRLocalize("pullDownToRefresh")
//    var releaseToRefresh = GTMRLocalize("releaseToRefresh")
//    var refreshSuccess = GTMRLocalize("refreshSuccess")
//    var refreshFailure = GTMRLocalize("refreshFailure")
//    var refreshing = GTMRLocalize("refreshing")
    var pullDownToRefresh = GTMRLocalize("Pull Down To Refresh")
    var releaseToRefresh = GTMRLocalize("Release To Refresh")
    var refreshSuccess = GTMRLocalize("Refresh Success")
    var refreshFailure = GTMRLocalize("Refresh Failure")
    var refreshing = GTMRLocalize("Refreshing")
    lazy var loaddingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        //indicator.backgroundColor = UIColor.white
        return indicator
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.messageLabel)
        self.contentView.addSubview(self.loaddingIndicator)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: frame.width * 0.5 - 70 - 20, y: frame.height * 0.5)
        loaddingIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        loaddingIndicator.mj_center = center
        messageLabel.frame = self.bounds
    }
    // MARK: SubGTMRefreshHeaderProtocol
    /// 控件的高度
    ///
    /// - Returns: 控件的高度
    public func contentHeight() -> CGFloat {
        return 60.0
    }
    public func toNormalState() {
        self.loaddingIndicator.isHidden = true
        self.loaddingIndicator.stopAnimating()
        messageLabel.text =  self.pullDownToRefresh
    }
    public func toRefreshingState() {
        self.loaddingIndicator.isHidden = false
        self.loaddingIndicator.startAnimating()
        messageLabel.text = self.refreshing
    }
    public func toPullingState() {
        self.loaddingIndicator.isHidden = true
        messageLabel.text = self.pullDownToRefresh
    }
    public func toWillRefreshState() {
        messageLabel.text = self.releaseToRefresh
        self.loaddingIndicator.isHidden = true
    }
    public func changePullingPercent(percent: CGFloat) {
        // here do nothing
    }
    public func willBeginEndRefershing(isSuccess: Bool) {
        self.loaddingIndicator.isHidden = true
        if isSuccess {
            messageLabel.text =  self.refreshSuccess
        } else {
            messageLabel.text =  self.refreshFailure
        }
    }
    public  func willCompleteEndRefershing() {
    }
}
public class DefaultGTMLoadMoreFooter: GTMLoadMoreFooter, SubGTMLoadMoreFooterProtocol {
    var pullUpToRefreshText: String = GTMRLocalize("pullUpToRefresh")
    public var loaddingText: String = GTMRLocalize("loadMore")
    public var noMoreDataText: String = GTMRLocalize("noMoreData")
    public var releaseLoadMoreText: String = GTMRLocalize("releaseLoadMore")
    lazy var loaddingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .gray
        indicator.backgroundColor = UIColor.white
        return indicator
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.messageLabel)
        self.contentView.addSubview(self.loaddingIndicator)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else {
            return
        }
    }
    // MARK: Layout
    public override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: frame.width * 0.5 - 70 - 30, y: frame.height * 0.5)
        loaddingIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        loaddingIndicator.mj_center = center
        messageLabel.frame = self.bounds
    }
    // MARK: SubGTMLoadMoreFooterProtocol
    /// 控件的高度
    ///
    /// - Returns: 控件的高度
    public func contentHeith() -> CGFloat {
        return 50.0
    }
    public func toNormalState() {
        self.loaddingIndicator.isHidden = true
        self.loaddingIndicator.stopAnimating()
        messageLabel.text =  self.pullUpToRefreshText
    }
    public func toNoMoreDataState() {
        self.loaddingIndicator.isHidden = true
        self.loaddingIndicator.stopAnimating()
        messageLabel.text =  self.noMoreDataText
    }
    public func toWillRefreshState() {
        messageLabel.text =  self.releaseLoadMoreText
    }
    public func toRefreshingState() {
        self.loaddingIndicator.isHidden = false
        self.loaddingIndicator.startAnimating()
        messageLabel.text =  self.loaddingText
    }
}
public extension UIScrollView {
    internal var gtmHeader: GTMRefreshHeader? {
        get {
            return objc_getAssociatedObject(self, &GTMRefreshConstant.associatedObjectGtmHeader) as? GTMRefreshHeader
        }
        set {
            objc_setAssociatedObject(self, &GTMRefreshConstant.associatedObjectGtmHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    internal var gtmFooter: GTMLoadMoreFooter? {
        get {
            return objc_getAssociatedObject(self, &GTMRefreshConstant.associatedObjectGtmFooter) as? GTMLoadMoreFooter
        }
        set {
            objc_setAssociatedObject(self, &GTMRefreshConstant.associatedObjectGtmFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 添加下拉刷新
    ///
    /// - Parameters:
    ///   - refreshHeader: 下拉刷新动效View必须继承GTMRefreshHeader并且要实现SubGTMRefreshHeaderProtocol，不传值的时候默认使用 DefaultGTMRefreshHeader
    ///   - refreshBlock: 刷新数据Block
    @discardableResult
    final public func gtm_addRefreshHeaderView(_ refreshHeader: GTMRefreshHeader? = DefaultGTMRefreshHeader(), refreshBlock:@escaping () -> Void) -> UIScrollView {
        guard refreshHeader is SubGTMRefreshHeaderProtocol  else {
            fatalError("refreshHeader must implement SubGTMRefreshHeaderProtocol")
        }
        if let header: GTMRefreshHeader = refreshHeader, let subProtocol = header.subProtocol {
            header.frame = CGRect(x: 0, y: 0, width: self.mj_w, height: subProtocol.contentHeight())
        }
        if gtmHeader != refreshHeader {
            gtmHeader?.removeFromSuperview()
            if let header:GTMRefreshHeader = refreshHeader {
                header.refreshBlock = refreshBlock
                self.insertSubview(header, at: 0)
                self.gtmHeader = header
            }
        }
        return self
    }
    /// 添加上拉加载
    ///
    /// - Parameters:
    ///   - loadMoreFooter: 上拉加载动效View必须继承GTMLoadMoreFooter，不传值的时候默认使用 DefaultGTMLoadMoreFooter
    ///   - refreshBlock: 加载更多数据Block
    @discardableResult
    final public func gtm_addLoadMoreFooterView(_ loadMoreFooter: GTMLoadMoreFooter? = DefaultGTMLoadMoreFooter(), loadMoreBlock:@escaping () -> Void) -> UIScrollView {
        guard loadMoreFooter is SubGTMLoadMoreFooterProtocol  else {
            fatalError("loadMoreFooter must implement SubGTMLoadMoreFooterProtocol")
        }
        if let footer: GTMLoadMoreFooter = loadMoreFooter, let subProtocol = footer.subProtocol {
            footer.frame = CGRect(x: 0, y: 0, width: self.mj_w, height: subProtocol.contentHeith())
        }
        if gtmFooter != loadMoreFooter {
            gtmFooter?.removeFromSuperview()
            if let footer:GTMLoadMoreFooter = loadMoreFooter {
                footer.loadMoreBlock = loadMoreBlock
                self.insertSubview(footer, at: 0)
                self.gtmFooter = footer
            }
        }
        return self
    }
    final public func triggerRefreshing(){
        self.gtmHeader?.autoRefreshing()
    }
    final public func endRefreshing(isSuccess: Bool) {
        self.gtmHeader?.endRefresing(isSuccess: isSuccess)
        if isSuccess {
            // 重置footer状态（防止footer还处在数据加载完成状态）
            self.gtmFooter?.state = .idle
        }
    }
    final public func endLoadMore(isNoMoreData: Bool) {
        self.gtmFooter?.endLoadMore(isNoMoreData: isNoMoreData)
    }
}
public extension UIScrollView {
    var mj_insetT: CGFloat {
        get { return contentInset.top }
        set {
            var inset = self.contentInset
            inset.top = newValue
            self.contentInset = inset
        }
    }
    var mj_insetB: CGFloat {
        get { return contentInset.bottom }
        set {
            var inset = self.contentInset
            inset.bottom = newValue
            self.contentInset = inset
        }
    }
    var mj_insetL: CGFloat {
        get { return contentInset.left }
        set {
            var inset = self.contentInset
            inset.left = newValue
            self.contentInset = inset
        }
    }
    var mj_insetR: CGFloat {
        get { return contentInset.right }
        set {
            var inset = self.contentInset
            inset.right = newValue
            self.contentInset = inset
        }
    }
    var mj_offsetX: CGFloat {
        get { return contentOffset.x }
        set {
            var offset = self.contentOffset
            offset.x = newValue
            self.contentOffset = offset
        }
    }
    var mj_offsetY: CGFloat {
        get { return contentOffset.y }
        set {
            var offset = self.contentOffset
            offset.y = newValue
            self.contentOffset = offset
        }
    }
    var mj_contentW: CGFloat {
        get { return contentSize.width }
        set {
            var size = self.contentSize
            size.width = newValue
            self.contentSize = size
        }
    }
    var mj_contentH: CGFloat {
        get { return contentSize.height }
        set {
            var size = self.contentSize
            size.height = newValue
            self.contentSize = size
        }
    }
}
public extension UIView {
    var mj_x: CGFloat {
        get { return frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    var mj_y: CGFloat {
        get { return frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    var mj_w: CGFloat {
        get { return frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    var mj_h: CGFloat {
        get { return frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    var mj_size: CGSize {
        get { return frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    var mj_origin: CGPoint {
        get { return frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    public var mj_center: CGPoint {
        get { return CGPoint(x: (frame.size.width-frame.origin.x)*0.5, y: (frame.size.height-frame.origin.y)*0.5) }
        set {
            var frame = self.frame
            frame.origin = CGPoint(x: newValue.x - frame.size.width*0.5, y: newValue.y - frame.size.height*0.5)
            self.frame = frame
        }
    }
}
class GTMRefreshConstant {
    static let slowAnimationDuration: TimeInterval = 0.4
    static let fastAnimationDuration: TimeInterval = 0.25
    static let keyPathContentOffset: String = "contentOffset"
    static let keyPathContentInset: String = "contentInset"
    static let keyPathContentSize: String = "contentSize"
    //    static let keyPathPanState: String = "state"
    static var associatedObjectGtmHeader = 0
    static var associatedObjectGtmFooter = 1
}
// 干嘛不直接用词典？
public func GTMRLocalize(_ string:String)->String{
    //    return NSLocalizedString(string, tableName: "Localize", bundle: Bundle(for: DefaultGTMRefreshHeader.self), value: "", comment: "")
    return string
}
public struct GTMRHeaderString{
    static public let pullDownToRefresh = GTMRLocalize("pullDownToRefresh")
    static public let releaseToRefresh = GTMRLocalize("releaseToRefresh")
    static public let refreshSuccess = GTMRLocalize("refreshSuccess")
    static public let refreshFailure = GTMRLocalize("refreshFailure")
    static public let refreshing = GTMRLocalize("refreshing")
}
public struct GTMRFooterString{
    static public let pullUpToRefresh = GTMRLocalize("pullUpToRefresh")
    static public let loadding = GTMRLocalize("loadMore")
    static public let noMoreData = GTMRLocalize("noMoreData")
    static public let releaseLoadMore = GTMRLocalize("releaseLoadMore")
    //static public let scrollAndTapToRefresh = GTMRLocalize("scrollAndTapToRefresh")
}
/// 状态枚举
///
/// - idle:         闲置
/// - pulling:      可以进行刷新
/// - refreshing:   正在刷新
/// - willRefresh:  即将刷新
/// - noMoreData:   没有更多数据
public enum GTMRefreshState {
    case idle
    case pulling
    case refreshing
    case willRefresh
    case noMoreData
}
public protocol SubGTMRefreshComponentProtocol {
    func scollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?)
    func scollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?)
}
open class GTMRefreshComponent: UIView {
    public var scrollView: UIScrollView?
    public var scrollViewOriginalInset: UIEdgeInsets?
    var state: GTMRefreshState = .idle
    // MARK: Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.backgroundColor = UIColor.clear
        self.state = .idle
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if self.state == .willRefresh {
            // 预防view还没显示出来就调用了beginRefreshing
            self.state = .refreshing
        }
    }
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview is UIScrollView else {
            return
        }
        self.removeAbserver()
        guard let superView = newSuperview else {
            return
        }
        self.mj_w = superView.mj_w
        self.mj_x = 0
        self.scrollView = newSuperview as! UIScrollView?
        // 设置永远支持垂直弹簧效果
        self.scrollView?.alwaysBounceVertical = true
        self.scrollViewOriginalInset = self.scrollView?.contentInset
        self.addObserver()
    }
    // MARK: KVO
    private func addObserver() {
        scrollView?.addObserver(self, forKeyPath: GTMRefreshConstant.keyPathContentOffset, options: .new, context: nil)
        scrollView?.addObserver(self, forKeyPath: GTMRefreshConstant.keyPathContentSize, options: .new, context: nil)
    }
    private func removeAbserver() {
        scrollView?.removeObserver(self, forKeyPath: GTMRefreshConstant.keyPathContentOffset)
        scrollView?.removeObserver(self, forKeyPath: GTMRefreshConstant.keyPathContentSize)
    }
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard isUserInteractionEnabled else {
            return
        }
        if let sub: SubGTMRefreshComponentProtocol = self as? SubGTMRefreshComponentProtocol {
            if keyPath == GTMRefreshConstant.keyPathContentSize {
                sub.scollViewContentSizeDidChange(change: change)
            }
            guard !self.isHidden else {
                return
            }
            if keyPath == GTMRefreshConstant.keyPathContentOffset {
                sub.scollViewContentOffsetDidChange(change: change)
            }
        }
    }
}
import UIKit
@objc public protocol SubGTMRefreshHeaderProtocol {
    /// 状态变成.idle
    @objc optional func toNormalState()
    /// 状态变成.refreshing
    @objc optional func toRefreshingState()
    /// 状态变成.pulling
    @objc optional func toPullingState()
    /// 状态变成.willRefresh
    @objc optional func toWillRefreshState()
    /// 下拉高度／触发高度 值改变
    @objc optional func changePullingPercent(percent: CGFloat)
    /// 开始结束动画前执行
    @objc optional func willBeginEndRefershing(isSuccess: Bool)
    /// 结束动画完成后执行
    @objc optional func willCompleteEndRefershing()
    /// 控件的高度
    ///
    /// - Returns: 控件的高度
    func contentHeight() -> CGFloat
}
open class GTMRefreshHeader: GTMRefreshComponent, SubGTMRefreshComponentProtocol {
    /// 刷新数据Block
    var refreshBlock: () -> Void = { }
    public var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    var insetTDelta: CGFloat = 0
    public var subProtocol: SubGTMRefreshHeaderProtocol? {
        get { return self as? SubGTMRefreshHeaderProtocol }
    }
    var pullingPercent: CGFloat = 0 {
        didSet {
            subProtocol?.changePullingPercent?(percent: pullingPercent)
        }
    }
    override var state: GTMRefreshState {
        didSet {
            guard oldValue != state else {
                return
            }
            switch state {
            case .idle:
                guard oldValue == GTMRefreshState.refreshing else {
                    return
                }
                // 恢复Inset
                UIView.animate(withDuration: GTMRefreshConstant.slowAnimationDuration, animations: {
                    self.scrollView?.mj_insetT += self.insetTDelta
                }, completion: { (isFinish) in
                    self.subProtocol?.willCompleteEndRefershing?()
                    // 执行刷新操作
                    self.subProtocol?.toNormalState?()
                })
            case .pulling:
                DispatchQueue.main.async {
                    self.subProtocol?.toPullingState?()
                }
            case .willRefresh:
                DispatchQueue.main.async {
                    self.subProtocol?.toWillRefreshState?()
                }
            case .refreshing:
                DispatchQueue.main.async {
                    UIView.animate(withDuration: GTMRefreshConstant.fastAnimationDuration, animations: {
                        self.subProtocol?.toRefreshingState?()
                        guard let originInset = self.scrollViewOriginalInset else {
                            return
                        }
                        let top: CGFloat = originInset.top + self.refreshingHoldHeight()
                        // 增加滚动区域top
                        self.scrollView?.mj_insetT = top
                        // 设置滚动位置
                        self.scrollView?.contentOffset = CGPoint(x: 0, y: -top)
                    }, completion: { (isFinish) in
                        // 执行刷新操作
                        self.refreshBlock()
                    })
                }
            default: break
            }
        }
    }
    // MARK: Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.contentView)
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleWidth
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard newSuperview != nil else {
            // newSuperview == nil 被移除的时候
            return
        }
        // newSuperview != nil 被添加到新的View上
        self.mj_y = -self.mj_h
    }
    // MARK: Layout
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
    }
    /// Loadding动画显示区域的高度(特殊的控件需要重写该方法，返回不同的数值)
    ///
    /// - Returns: Loadding动画显示区域的高度
    open func refreshingHoldHeight() -> CGFloat {
        return self.mj_h // 默认使用控件高度
    }
    /// 即将触发刷新的高度(特殊的控件需要重写该方法，返回不同的数值)
    ///
    /// - Returns: 触发刷新的高度
    open func willRefresHeight() -> CGFloat {
        return self.mj_h // 默认使用控件高度
    }
    // MARK: SubGTMRefreshComponentProtocol
    open func scollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        guard let scrollV = self.scrollView else {
            return
        }
        let originalInset = self.scrollViewOriginalInset!
        if state == .refreshing {
            guard let _ = self.window else {
                return
            }
            // 考虑SectionHeader停留时的高度
            // 取最大者： max (-scrollV.mj_offsetY,originalInset.top)
            var insetT: CGFloat = -scrollV.mj_offsetY > originalInset.top ? -scrollV.mj_offsetY : originalInset.top
            // 取最小者： max (insetT,originalInset.top,self.refreshingHoldHeight() + originalInset.top)
            insetT = insetT > self.refreshingHoldHeight() + originalInset.top ? self.refreshingHoldHeight() + originalInset.top : insetT
            print("insetT",insetT,-scrollV.mj_offsetY)
            scrollV.mj_insetT = insetT
            self.insetTDelta = originalInset.top - insetT
            return
        }
        // 跳转到下一个控制器时，contentInset可能会变
        self.scrollViewOriginalInset = scrollV.contentInset
        // 当前的contentOffset
        let offsetY: CGFloat = scrollV.mj_offsetY
        // 头部控件刚好出现的offsetY
        let headerInOffsetY: CGFloat = -originalInset.top
        // 如果是向上滚动头部控件还没出现，直接返回
        guard offsetY <= headerInOffsetY else {
            return
        }
        // 普通 和 即将刷新 的临界点
        let idle2pullingOffsetY: CGFloat = headerInOffsetY - self.willRefresHeight()
        if scrollV.isDragging {
            switch state {
            case .idle:
                if offsetY <= headerInOffsetY {
                    state = .pulling
                }
            case .pulling:
                if offsetY <= idle2pullingOffsetY {
                    state = .willRefresh
                } else {
                    self.pullingPercent = (headerInOffsetY - offsetY) / self.willRefresHeight()
                }
            case .willRefresh:
                if offsetY > idle2pullingOffsetY {
                    state = .idle
                }
            default: break
            }
        } else {
            // 停止Drag && 并且是即将刷新状态
            if state == .willRefresh {
                // 开始刷新
                self.pullingPercent = 1.0
                // 只要正在刷新，就完全显示
                if self.window != nil {
                    state = .refreshing
                } else {
                    // 预防正在刷新中时，调用本方法使得header inset回置失败
                    if state != .refreshing {
                        state = .willRefresh
                        // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                        self.setNeedsDisplay()
                    }
                }
            }
        }
    }
    open func scollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        // here do nothing
    }
    // MARK: Public API
    final public func autoRefreshing(){
        if self.window != nil {
            self.state = .refreshing
        }else{
            if state != .refreshing{
                self.state = .willRefresh
            }
        }
    }
    /// 结束刷新
    final public func endRefresing(isSuccess: Bool) {
        subProtocol?.willBeginEndRefershing?(isSuccess: isSuccess)
        self.state = .idle
    }
}
@objc public protocol SubGTMLoadMoreFooterProtocol {
    @objc optional func toNormalState()
    @objc optional func toNoMoreDataState()
    @objc optional func toWillRefreshState()
    @objc optional func toRefreshingState()
    /// 控件的高度(自定义控件通过该方法设置自定义高度)
    ///
    /// - Returns: 控件的高度
    func contentHeith() -> CGFloat
}
open class GTMLoadMoreFooter: GTMRefreshComponent, SubGTMRefreshComponentProtocol {
    /// 加载更多Block
    var loadMoreBlock: () -> Void = {}
    public var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    var lastBottomDelta: CGFloat = 0.0
    public var subProtocol: SubGTMLoadMoreFooterProtocol? {
        get { return self as? SubGTMLoadMoreFooterProtocol }
    }
    override var state: GTMRefreshState {
        didSet {
            guard oldValue != state, let scrollV = scrollView else {
                return
            }
            switch state {
            case .noMoreData, .idle:
                guard oldValue == .refreshing else {
                    if self.state == .noMoreData {
                        self.subProtocol?.toNoMoreDataState?()
                    }
                    return
                }
                // 结束加载
                UIView.animate(withDuration: GTMRefreshConstant.slowAnimationDuration, animations: {
                    scrollV.mj_insetB -= self.lastBottomDelta
                }, completion: { (isComplet) in
                    self.state == .idle ? self.subProtocol?.toNormalState?() : self.subProtocol?.toNoMoreDataState?()
                })
            case .refreshing:
                // 展示正在加载动效
                UIView.animate(withDuration: GTMRefreshConstant.fastAnimationDuration, animations: {
                    let overflowHeight = self.contentOverflowHeight
                    var toInsetB = self.mj_h + (self.scrollViewOriginalInset?.bottom)!
                    if overflowHeight < 0 {
                        // 如果内容还没占满
                        toInsetB -= overflowHeight
                    }
                    self.lastBottomDelta = toInsetB - scrollV.mj_insetB
                    scrollV.mj_insetB = toInsetB
                    scrollV.mj_offsetY = self.footerCloseOffsetY + self.mj_h
                }, completion: { (isComplet) in
                    self.loadMoreBlock()
                    self.subProtocol?.toRefreshingState?()
                })
            case .willRefresh:
                DispatchQueue.main.async {
                    self.subProtocol?.toWillRefreshState?()
                }
            default: break
            }
        }
    }
    // MARK: Life Cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.contentView)
        self.contentView.autoresizingMask = UIViewAutoresizing.flexibleWidth
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.scollViewContentSizeDidChange(change: nil)
    }
    // MARK: Layout
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds
    }
    // MARK: SubGTMRefreshComponentProtocol
    open func scollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        // refreshing或者noMoreData状态，直接返回
        guard state != .refreshing, state != .noMoreData, let scrollV = scrollView else {
            return
        }
        self.scrollViewOriginalInset = scrollV.contentInset
        let currentOffsetY = scrollV.mj_offsetY
        let footerCloseOffsetY = self.footerCloseOffsetY
        guard currentOffsetY >= footerCloseOffsetY else {
            // footer还没出现， 直接返回
            return
        }
        if scrollV.isDragging {
            // 拖动状态
            let willLoadMoreOffsetY = footerCloseOffsetY + self.mj_h
            switch currentOffsetY {
            case footerCloseOffsetY...willLoadMoreOffsetY:
                state = .pulling
            case willLoadMoreOffsetY...(willLoadMoreOffsetY + 1000):
                state = .willRefresh
            default: break
            }
        } else {
            // 停止拖动状态
            switch state {
            case .pulling:
                state = .idle
            case .willRefresh:
                state = .refreshing
            default: break
            }
        }
    }
    open func scollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        // here do nothing
        guard let scrollV = scrollView, let originInset = scrollViewOriginalInset else {
            return
        }
        // 重设位置
        let contentH = scrollV.mj_contentH  // 内容高度
        let visibleH = scrollV.mj_h - originInset.top - originInset.bottom  // 可见区域高度
        self.mj_y = contentH > visibleH ? contentH : visibleH
    }
    // MARK: Public
    public func endLoadMore(isNoMoreData: Bool) {
        if isNoMoreData {
            state = .noMoreData
        } else {
            state = .idle
        }
    }
    // MARK: Private
    /// ScrollView内容溢出的高度
    private var contentOverflowHeight: CGFloat {
        get {
            guard let scrollV = scrollView, let originInset = scrollViewOriginalInset else {
                return 0.0
            }
            // ScrollView内容占满的高度
            let fullContentHeight = scrollV.mj_h - originInset.bottom - originInset.top
            return scrollV.mj_contentH - fullContentHeight
        }
    }
    /// 上拉刷新控件即将出现时的OffsetY
    private var footerCloseOffsetY: CGFloat {
        get {
            guard let _ = scrollView, let originInset = scrollViewOriginalInset else {
                return 0.0
            }
            let overflowHeight = contentOverflowHeight
            if overflowHeight > 0 {
                return overflowHeight - originInset.top
            } else {
                return -originInset.top
            }
        }
    }
}
import UIKit
import ObjectiveC
