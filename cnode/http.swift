
//
//  Upload.swift
//  SwiftHTTP
//
//  Created by Dalton Cherry on 6/5/14.
//  Copyright (c) 2014 Vluxe. All rights reserved.
//

import Foundation

#if os(iOS)
    import MobileCoreServices
#endif

/**
 Upload errors
 */
enum HTTPUploadError: Error {
    case noFileUrl
    case noData
}

/**
 This is how to upload files in SwiftHTTP. The upload object represents a file to upload by either a data blob or a url (which it reads off disk).
 */
open class Upload: NSObject, NSCoding {
    var fileUrl: URL? {
        didSet {
            getMimeType()
        }
    }
    var mimeType: String?
    var data: Data?
    var fileName: String?
    
    /**
     Tries to determine the mime type from the fileUrl extension.
     */
    func getMimeType() {
        mimeType = "application/octet-stream"
        guard let url = fileUrl else { return }
        #if os(iOS) || os(OSX) //for watchOS support
            guard let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, url.pathExtension as CFString, nil) else { return }
            guard let str = UTTypeCopyPreferredTagWithClass(UTI.takeRetainedValue(), kUTTagClassMIMEType) else { return }
            mimeType = str.takeRetainedValue() as String
        #endif
    }
    
    /**
     Reads the data from disk or from memory. Throws an error if no data or file is found.
     */
    open func getData() -> (data: Data?, error: Error?) {
        if let d = data {
            return (d, nil)
        }
        guard let url = fileUrl else { return (nil, HTTPUploadError.noFileUrl) }
        fileName = url.lastPathComponent
        do {
            let d = try Data(contentsOf: url, options: .mappedIfSafe)
            data = d
            getMimeType()
            return (d, nil)
        } catch let error {
            return (nil, error)
        }
    }
    
    /**
     Standard NSCoder support
     */
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(self.fileUrl, forKey: "fileUrl")
        aCoder.encode(self.mimeType, forKey: "mimeType")
        aCoder.encode(self.fileName, forKey: "fileName")
        aCoder.encode(self.data, forKey: "data")
    }
    
    /**
     Required for NSObject support (because of NSCoder, it would be a struct otherwise!)
     */
    public override init() {
        super.init()
    }
    
    required public convenience init(coder aDecoder: NSCoder) {
        self.init()
        fileUrl = aDecoder.decodeObject(forKey: "fileUrl") as? URL
        mimeType = aDecoder.decodeObject(forKey: "mimeType") as? String
        fileName = aDecoder.decodeObject(forKey: "fileName") as? String
        data = aDecoder.decodeObject(forKey: "data") as? Data
    }
    
    /**
     Initializes a new Upload object with a fileUrl. The fileName and mimeType will be infered.
     
     -parameter fileUrl: The fileUrl is a standard url path to a file.
     */
    public convenience init(fileUrl: URL) {
        self.init()
        self.fileUrl = fileUrl
    }
    
    /**
     Initializes a new Upload object with a data blob.
     
     -parameter data: The data is a NSData representation of a file's data.
     -parameter fileName: The fileName is just that. The file's name.
     -parameter mimeType: The mimeType is just that. The mime type you would like the file to uploaded as.
     */
    ///upload a file from a a data blob. Must add a filename and mimeType as that can't be infered from the data
    public convenience init(data: Data, fileName: String, mimeType: String) {
        self.init()
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
//
//  HTTPStatusCode.swift
//  SwiftHTTP
//
//  Created by Yu Kadowaki on 7/12/15.
//  Copyright (c) 2015 Vluxe. All rights reserved.
//

import Foundation

/// HTTP Status Code (RFC 2616)
public enum HTTPStatusCode: Int {
    case `continue` = 100,
    switchingProtocols = 101
    
    case ok = 200,
    created = 201,
    accepted = 202,
    nonAuthoritativeInformation = 203,
    noContent = 204,
    resetContent = 205,
    partialContent = 206
    
    case multipleChoices = 300,
    movedPermanently = 301,
    found = 302,
    seeOther = 303,
    notModified = 304,
    useProxy = 305,
    unused = 306,
    temporaryRedirect = 307
    
    case badRequest = 400,
    unauthorized = 401,
    paymentRequired = 402,
    forbidden = 403,
    notFound = 404,
    methodNotAllowed = 405,
    notAcceptable = 406,
    proxyAuthenticationRequired = 407,
    requestTimeout = 408,
    conflict = 409,
    gone = 410,
    lengthRequired = 411,
    preconditionFailed = 412,
    requestEntityTooLarge = 413,
    requestUriTooLong = 414,
    unsupportedMediaType = 415,
    requestedRangeNotSatisfiable = 416,
    expectationFailed = 417
    
    case internalServerError = 500,
    notImplemented = 501,
    badGateway = 502,
    serviceUnavailable = 503,
    gatewayTimeout = 504,
    httpVersionNotSupported = 505
    
    case invalidUrl = -1001
    
    case unknownStatus = 0
    
    init(statusCode: Int) {
        self = HTTPStatusCode(rawValue: statusCode) ?? .unknownStatus
    }
    
    public var statusDescription: String {
        get {
            switch self {
            case .continue:
                return "Continue"
            case .switchingProtocols:
                return "Switching protocols"
            case .ok:
                return "OK"
            case .created:
                return "Created"
            case .accepted:
                return "Accepted"
            case .nonAuthoritativeInformation:
                return "Non authoritative information"
            case .noContent:
                return "No content"
            case .resetContent:
                return "Reset content"
            case .partialContent:
                return "Partial Content"
            case .multipleChoices:
                return "Multiple choices"
            case .movedPermanently:
                return "Moved Permanently"
            case .found:
                return "Found"
            case .seeOther:
                return "See other Uri"
            case .notModified:
                return "Not modified"
            case .useProxy:
                return "Use proxy"
            case .unused:
                return "Unused"
            case .temporaryRedirect:
                return "Temporary redirect"
            case .badRequest:
                return "Bad request"
            case .unauthorized:
                return "Access denied"
            case .paymentRequired:
                return "Payment required"
            case .forbidden:
                return "Forbidden"
            case .notFound:
                return "Page not found"
            case .methodNotAllowed:
                return "Method not allowed"
            case .notAcceptable:
                return "Not acceptable"
            case .proxyAuthenticationRequired:
                return "Proxy authentication required"
            case .requestTimeout:
                return "Request timeout"
            case .conflict:
                return "Conflict request"
            case .gone:
                return "Page is gone"
            case .lengthRequired:
                return "Lack content length"
            case .preconditionFailed:
                return "Precondition failed"
            case .requestEntityTooLarge:
                return "Request entity is too large"
            case .requestUriTooLong:
                return "Request uri is too long"
            case .unsupportedMediaType:
                return "Unsupported media type"
            case .requestedRangeNotSatisfiable:
                return "Request range is not satisfiable"
            case .expectationFailed:
                return "Expected request is failed"
            case .internalServerError:
                return "Internal server error"
            case .notImplemented:
                return "Server does not implement a feature for request"
            case .badGateway:
                return "Bad gateway"
            case .serviceUnavailable:
                return "Service unavailable"
            case .gatewayTimeout:
                return "Gateway timeout"
            case .httpVersionNotSupported:
                return "Http version not supported"
            case .invalidUrl:
                return "Invalid url"
            default:
                return "Unknown status code"
            }
        }
    }
}
//
//  Request.swift
//  SwiftHTTP
//
//  Created by Dalton Cherry on 8/16/15.
//  Copyright © 2015 vluxe. All rights reserved.
//

import Foundation


extension String {
    /**
     A simple extension to the String object to encode it for web request.
     
     :returns: Encoded version of of string it was called as.
     */
    var escaped: String? {
        var set = CharacterSet()
        set.formUnion(CharacterSet.urlQueryAllowed)
        set.remove(charactersIn: "[].:/?&=;+!@#$()',*\"") // remove the HTTP ones from the set.
        return self.addingPercentEncoding(withAllowedCharacters: set)
    }
    
    /**
     A simple extension to the String object to url encode quotes only.
     
     :returns: string with .
     */
    var quoteEscaped: String {
        return self.replacingOccurrences(of: "\"", with: "%22").replacingOccurrences(of: "'", with: "%27")
    }
}

/**
 The standard HTTP Verbs
 */
public enum HTTPVerb: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case HEAD = "HEAD"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
    case OPTIONS = "OPTIONS"
    case TRACE = "TRACE"
    case CONNECT = "CONNECT"
    case UNKNOWN = "UNKNOWN"
}

/**
 This is used to create key/value pairs of the parameters
 */
public struct HTTPPair {
    var key: String?
    let storeVal: AnyObject
    /**
     Create the object with a possible key and a value
     */
    init(key: String?, value: AnyObject) {
        self.key = key
        self.storeVal = value
    }
    /**
     Computed property of the string representation of the storedVal
     */
    var upload: Upload? {
        return storeVal as? Upload
    }
    /**
     Computed property of the string representation of the storedVal
     */
    var value: String {
        if storeVal is NSNull {
            return ""
        } else if let v = storeVal as? String {
            return v
        } else {
            return storeVal.description ?? ""
        }
    }
    /**
     Computed property of the string representation of the storedVal escaped for URLs
     */
    var escapedValue: String {
        let v = value.escaped ?? ""
        if let k = key {
            if let escapedKey = k.escaped {
                return "\(escapedKey)=\(v)"
            }
        }
        return ""
    }
}

/**
 This is super gross, but it is just an edge case, I'm willing to live with it
 versus trying to handle such an rare need with more code and confusion
 */
public class HTTPParameterProtocolSettings {
    public static var sendEmptyArray = false
}

/**
 This protocol is used to make the dictionary and array serializable into key/value pairs.
 */
public protocol HTTPParameterProtocol {
    func createPairs(_ key: String?) -> [HTTPPair]
}

/**
 Support for the Dictionary type as an HTTPParameter.
 */
extension Dictionary: HTTPParameterProtocol {
    public func createPairs(_ key: String?) -> [HTTPPair] {
        var collect = [HTTPPair]()
        for (k, v) in self {
            if let nestedKey = k as? String {
                let useKey = key != nil ? "\(key!)[\(nestedKey)]" : nestedKey
                if let subParam = v as? HTTPParameterProtocol {
                    collect.append(contentsOf: subParam.createPairs(useKey))
                } else {
                    collect.append(HTTPPair(key: useKey, value: v as AnyObject))
                }
            }
        }
        return collect
    }
}

/**
 Support for the Array type as an HTTPParameter.
 */
extension Array: HTTPParameterProtocol {
    
    public func createPairs(_ key: String?) -> [HTTPPair] {
        var collect = [HTTPPair]()
        for v in self {
            let useKey = key != nil ? "\(key!)[]" : key
            if let subParam = v as? HTTPParameterProtocol {
                collect.append(contentsOf: subParam.createPairs(useKey))
            } else {
                collect.append(HTTPPair(key: useKey, value: v as AnyObject))
            }
        }
        if HTTPParameterProtocolSettings.sendEmptyArray && collect.count == 0 {
            collect.append(HTTPPair(key: key, value: "[]" as AnyObject))
        }
        return collect
    }
}

/**
 Support for the Upload type as an HTTPParameter.
 */
extension Upload: HTTPParameterProtocol {
    public func createPairs(_ key: String?) -> Array<HTTPPair> {
        var collect = Array<HTTPPair>()
        collect.append(HTTPPair(key: key, value: self))
        return collect
    }
}

/**
 Adds convenience methods to URLRequest to make using it with HTTP much simpler.
 */
extension URLRequest {
    /**
     Convenience init to allow init with a string.
     -parameter urlString: The string representation of a URL to init with.
     */
    public init?(urlString: String, parameters: HTTPParameterProtocol? = nil, headers: [String: String]? = nil, cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy, timeoutInterval: TimeInterval = 60) {
        if let url = URL(string: urlString) {
            self.init(url: url)
        } else {
            return nil
        }
        if let params = parameters {
            let _ = appendParameters(params)
        }
        if let heads = headers {
            for (key,value) in heads {
                addValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    /**
     Convenience method to avoid having to use strings and allow using an enum
     */
    public var verb: HTTPVerb {
        set {
            httpMethod = newValue.rawValue
        }
        get {
            if let verb = httpMethod, let v = HTTPVerb(rawValue: verb) {
                return v
            }
            return .UNKNOWN
        }
    }
    
    /**
     Used to update the content type in the HTTP header as needed
     */
    var contentTypeKey: String {
        return "Content-Type"
    }
    
    /**
     append the parameters using the standard HTTP Query model.
     This is parameters in the query string of the url (e.g. ?first=one&second=two for GET, HEAD, DELETE.
     It uses 'application/x-www-form-urlencoded' for the content type of POST/PUT requests that don't contains files.
     If it contains a file it uses `multipart/form-data` for the content type.
     -parameter parameters: The container (array or dictionary) to convert and append to the URL or Body
     */
    public mutating func appendParameters(_ parameters: HTTPParameterProtocol) -> Error? {
        if isURIParam() {
            appendParametersAsQueryString(parameters)
        } else if containsFile(parameters) {
            return appendParametersAsMultiPartFormData(parameters)
        } else {
            appendParametersAsUrlEncoding(parameters)
        }
        return nil
    }
    
    /**
     append the parameters as a HTTP Query string. (e.g. domain.com?first=one&second=two)
     -parameter parameters: The container (array or dictionary) to convert and append to the URL
     */
    public mutating func appendParametersAsQueryString(_ parameters: HTTPParameterProtocol) {
        let queryString = parameters.createPairs(nil).map({ (pair) in
            return pair.escapedValue
        }).joined(separator: "&")
        if let u = self.url , queryString.characters.count > 0 {
            let para = u.query != nil ? "&" : "?"
            self.url = URL(string: "\(u.absoluteString)\(para)\(queryString)")
        }
    }
    
    /**
     append the parameters as a url encoded string. (e.g. in the body of the request as: first=one&second=two)
     -parameter parameters: The container (array or dictionary) to convert and append to the HTTP body
     */
    public mutating func appendParametersAsUrlEncoding(_ parameters: HTTPParameterProtocol) {
        if value(forHTTPHeaderField: contentTypeKey) == nil {
            var contentStr = "application/x-www-form-urlencoded"
            if let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue)) {
                contentStr += "; charset=\(charset)"
            }
            setValue(contentStr, forHTTPHeaderField:contentTypeKey)
        }
        let queryString = parameters.createPairs(nil).map({ (pair) in
            return pair.escapedValue
        }).joined(separator: "&")
        httpBody = queryString.data(using: .utf8)
    }
    
    /**
     append the parameters as a multpart form body. This is the type normally used for file uploads.
     -parameter parameters: The container (array or dictionary) to convert and append to the HTTP body
     */
    public mutating func appendParametersAsMultiPartFormData(_ parameters: HTTPParameterProtocol) -> Error? {
        let boundary = "Boundary+\(arc4random())\(arc4random())"
        if value(forHTTPHeaderField: contentTypeKey) == nil {
            setValue("multipart/form-data; boundary=\(boundary)",
                forHTTPHeaderField:contentTypeKey)
        }
        let mutData = NSMutableData()
        let multiCRLF = "\r\n"
        mutData.append("--\(boundary)".data(using: .utf8)!)
        for pair in parameters.createPairs(nil) {
            guard let key = pair.key else { continue } //this won't happen, but just to properly unwrap
            if let upload = pair.upload {
                let resp = upload.getData()
                if let error = resp.error {
                    return error
                }
                mutData.append("\(multiCRLF)".data(using: .utf8)!)
                if let data = resp.data {
                    mutData.append(multiFormHeader(key, fileName: upload.fileName,
                                                   type: upload.mimeType, multiCRLF: multiCRLF).data(using: .utf8)!)
                    mutData.append(data)
                } else {
                    return HTTPUploadError.noData
                }
            } else {
                mutData.append("\(multiCRLF)".data(using: .utf8)!)
                let str = "\(multiFormHeader(key, fileName: nil, type: nil, multiCRLF: multiCRLF))\(pair.value)"
                mutData.append(str.data(using: .utf8)!)
            }
            mutData.append("\(multiCRLF)--\(boundary)".data(using: .utf8)!)
        }
        mutData.append("--\(multiCRLF)".data(using: .utf8)!)
        httpBody = mutData as Data
        return nil
    }
    
    /**
     Helper method to create the multipart form data
     */
    func multiFormHeader(_ name: String, fileName: String?, type: String?, multiCRLF: String) -> String {
        var str = "Content-Disposition: form-data; name=\"\(name.quoteEscaped)\""
        if let n = fileName {
            str += "; filename=\"\(n.quoteEscaped)\""
        }
        str += multiCRLF
        if let t = type {
            str += "Content-Type: \(t)\(multiCRLF)"
        }
        str += multiCRLF
        return str
    }
    
    
    /**
     send the parameters as a body of JSON
     -parameter parameters: The container (array or dictionary) to convert and append to the URL or Body
     */
    public mutating func appendParametersAsJSON(_ parameters: HTTPParameterProtocol) -> Error? {
        if isURIParam() {
            appendParametersAsQueryString(parameters)
        } else {
            do {
                httpBody = try JSONSerialization.data(withJSONObject: parameters as AnyObject, options: JSONSerialization.WritingOptions())
            } catch let error {
                return error
            }
            var contentStr = "application/json"
            if let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue)) {
                contentStr += "; charset=\(charset)"
            }
            setValue(contentStr, forHTTPHeaderField: contentTypeKey)
        }
        return nil
    }
    
    /**
     Check if the request requires the parameters to be appended to the URL
     */
    public func isURIParam() -> Bool {
        if verb == .GET || verb == .HEAD || verb == .DELETE {
            return true
        }
        return false
    }
    
    /**
     check if the parameters contain a file object within them
     -parameter parameters: The parameters to search through for an upload object
     */
    public func containsFile(_ parameters: HTTPParameterProtocol) -> Bool {
        for pair in parameters.createPairs(nil) {
            if let _ = pair.upload {
                return true
            }
        }
        return false
    }
}
//
//  Operation.swift
//  SwiftHTTP
//
//  Created by Dalton Cherry on 8/2/15.
//  Copyright © 2015 vluxe. All rights reserved.
//

import Foundation

enum HTTPOptError: Error {
    case invalidRequest
}

/**
 This protocol exist to allow easy and customizable swapping of a serializing format within an class methods of HTTP.
 */
public protocol HTTPSerializeProtocol {
    
    /**
     implement this protocol to support serializing parameters to the proper HTTP body or URL
     -parameter request: The URLRequest object you will modify to add the parameters to
     -parameter parameters: The container (array or dictionary) to convert and append to the URL or Body
     */
    func serialize(_ request: inout URLRequest, parameters: HTTPParameterProtocol) -> Error?
}

/**
 Standard HTTP encoding
 */
public struct HTTPParameterSerializer: HTTPSerializeProtocol {
    public init() { }
    public func serialize(_ request: inout URLRequest, parameters: HTTPParameterProtocol) -> Error? {
        return request.appendParameters(parameters)
    }
}

/**
 Send the data as a JSON body
 */
public struct JSONParameterSerializer: HTTPSerializeProtocol {
    public init() { }
    public func serialize(_ request: inout URLRequest, parameters: HTTPParameterProtocol) -> Error? {
        return request.appendParametersAsJSON(parameters)
    }
}

/**
 All the things of an HTTP response
 */
open class Response {
    /// The header values in HTTP response.
    open var headers: Dictionary<String,String>?
    /// The mime type of the HTTP response.
    open var mimeType: String?
    /// The suggested filename for a downloaded file.
    open var suggestedFilename: String?
    /// The body data of the HTTP response.
    open var data: Data {
        return collectData as Data
    }
    /// The status code of the HTTP response.
    open var statusCode: Int?
    /// The URL of the HTTP response.
    open var URL: Foundation.URL?
    /// The Error of the HTTP response (if there was one).
    open var error: Error?
    ///Returns the response as a string
    open var text: String? {
        return  String(data: data, encoding: .utf8)
    }
    ///get the description of the response
    open var description: String {
        var buffer = ""
        if let u = URL {
            buffer += "URL:\n\(u)\n\n"
        }
        if let code = self.statusCode {
            buffer += "Status Code:\n\(code)\n\n"
        }
        if let heads = headers {
            buffer += "Headers:\n"
            for (key, value) in heads {
                buffer += "\(key): \(value)\n"
            }
            buffer += "\n"
        }
        if let t = text {
            buffer += "Payload:\n\(t)\n"
        }
        return buffer
    }
    ///private things
    
    ///holds the collected data
    var collectData = NSMutableData()
    ///finish closure
    var completionHandler:((Response) -> Void)?
    
    //progress closure. Progress is between 0 and 1.
    var progressHandler:((Float) -> Void)?
    
    //download closure. the URL is the file URL where the temp file has been download.
    //This closure will be called so you can move the file where you desire.
    var downloadHandler:((Response, URL) -> Void)?
    
    ///This gets called on auth challenges. If nil, default handling is use.
    ///Returning nil from this method will cause the request to be rejected and cancelled
    var auth:((URLAuthenticationChallenge) -> URLCredential?)?
    
    ///This is for doing SSL pinning
    var security: HTTPSecurity?
}

/**
 The class that does the magic. Is a subclass of NSOperation so you can use it with operation queues or just a good ole HTTP request.
 */
open class HTTP {
    /**
     Get notified with a request finishes.
     */
    open var onFinish:((Response) -> Void)? {
        didSet {
            if let handler = onFinish {
                DelegateManager.sharedInstance.addTask(task, completionHandler: { (response: Response) in
                    handler(response)
                })
            }
        }
    }
    ///This is for handling authenication
    open var auth:((URLAuthenticationChallenge) -> URLCredential?)? {
        set {
            guard let resp = DelegateManager.sharedInstance.responseForTask(task) else { return }
            resp.auth = newValue
        }
        get {
            guard let resp = DelegateManager.sharedInstance.responseForTask(task) else { return nil }
            return resp.auth
        }
    }
    
    ///This is for doing SSL pinning
    open var security: HTTPSecurity? {
        set {
            guard let resp = DelegateManager.sharedInstance.responseForTask(task) else { return }
            resp.security = newValue
        }
        get {
            guard let resp = DelegateManager.sharedInstance.responseForTask(task) else { return nil }
            return resp.security
        }
    }
    
    ///This is for monitoring progress
    open var progress: ((Float) -> Void)? {
        set {
            guard let resp = DelegateManager.sharedInstance.responseForTask(task) else { return }
            resp.progressHandler = newValue
        }
        get {
            guard let resp = DelegateManager.sharedInstance.responseForTask(task) else { return nil }
            return resp.progressHandler
        }
    }
    
    ///This is for handling downloads
    open var downloadHandler: ((Response, URL) -> Void)? {
        set {
            guard let resp = DelegateManager.sharedInstance.responseForTask(task) else { return }
            resp.downloadHandler = newValue
        }
        get {
            guard let resp = DelegateManager.sharedInstance.responseForTask(task) else { return nil }
            return resp.downloadHandler
        }
    }
    
    ///the actual task
    var task: URLSessionTask!
    
    /**
     creates a new HTTP request.
     */
    public init(_ req: URLRequest, session: URLSession = SharedSession.defaultSession, isDownload: Bool = false) {
        if isDownload {
            task = session.downloadTask(with: req)
        } else {
            task = session.dataTask(with: req)
        }
        DelegateManager.sharedInstance.addResponseForTask(task)
    }
    
    /**
     start/sends the HTTP task with a completionHandler. Use this when *NOT* using an NSOperationQueue.
     */
    open func run(_ completionHandler: ((Response) -> Void)? = nil) {
        if let handler = completionHandler {
            onFinish = handler
        }
        task.resume()
    }
    
    /**
     Cancel the running task
     */
    open func cancel() {
        task.cancel()
    }
    
    /**
     Class method to run a GET request that handles the URLRequest and parameter encoding for you.
     */
    open class func GET(_ url: String, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil,
                        requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completionHandler: ((Response) -> Void)? = nil)  {
        Run(url, method: .GET, parameters: parameters, headers: headers, requestSerializer: requestSerializer, completionHandler: completionHandler)
    }
    
    /**
     Class method to run a HEAD request that handles the URLRequest and parameter encoding for you.
     */
    open class func HEAD(_ url: String, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil, requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completionHandler: ((Response) -> Void)? = nil)  {
        Run(url, method: .HEAD, parameters: parameters, headers: headers, requestSerializer: requestSerializer, completionHandler: completionHandler)
    }
    
    /**
     Class method to run a DELETE request that handles the URLRequest and parameter encoding for you.
     */
    open class func DELETE(_ url: String, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil, requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completionHandler: ((Response) -> Void)? = nil) {
        Run(url, method: .DELETE, parameters: parameters, headers: headers, requestSerializer: requestSerializer, completionHandler: completionHandler)
    }
    
    /**
     Class method to run a POST request that handles the URLRequest and parameter encoding for you.
     */
    open class func POST(_ url: String, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil, requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completionHandler: ((Response) -> Void)? = nil) {
        Run(url, method: .POST, parameters: parameters, headers: headers, requestSerializer: requestSerializer, completionHandler: completionHandler)
    }
    
    /**
     Class method to run a PUT request that handles the URLRequest and parameter encoding for you.
     */
    open class func PUT(_ url: String, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil,
                        requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completionHandler: ((Response) -> Void)? = nil) {
        Run(url, method: .PUT, parameters: parameters, headers: headers, requestSerializer: requestSerializer, completionHandler: completionHandler)
    }
    
    /**
     Class method to run a PUT request that handles the URLRequest and parameter encoding for you.
     */
    open class func PATCH(_ url: String, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil, requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completionHandler: ((Response) -> Void)? = nil) {
        Run(url, method: .PATCH, parameters: parameters, headers: headers, requestSerializer: requestSerializer, completionHandler: completionHandler)
    }
    
    class func Run(_ url: String, method: HTTPVerb, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil, requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completionHandler: ((Response) -> Void)? = nil)  {
        guard let task = HTTP.New(url, method: method, parameters: parameters, headers: headers, requestSerializer: requestSerializer, completionHandler: completionHandler) else {return}
        task.run()
    }
    
    /**
     Class method to create a Download request that handles the URLRequest and parameter encoding for you.
     */
    open class func Download(_ url: String, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil,
                             requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completion:@escaping ((Response, URL) -> Void)) {
        guard let task = HTTP.New(url, method: .GET, parameters: parameters, headers: headers, requestSerializer: requestSerializer) else {return}
        task.downloadHandler = completion
        task.run()
    }
    
    /**
     Class method to create a HTTP request that handles the URLRequest and parameter encoding for you.
     */
    open class func New(_ url: String, method: HTTPVerb, parameters: HTTPParameterProtocol? = nil, headers: [String:String]? = nil, requestSerializer: HTTPSerializeProtocol = HTTPParameterSerializer(), completionHandler: ((Response) -> Void)? = nil) -> HTTP? {
        guard var req = URLRequest(urlString: url, headers: headers) else {
            guard let handler = completionHandler else { return nil }
            let resp = Response()
            resp.error = HTTPOptError.invalidRequest
            handler(resp)
            return nil
        }
        if let handler = DelegateManager.sharedInstance.requestHandler {
            handler(req)
        }
        req.verb = method
        if let params = parameters {
            if let error = requestSerializer.serialize(&req, parameters: params) {
                guard let handler = completionHandler else { return nil }
                let resp = Response()
                resp.error = error
                handler(resp)
                return nil
            }
        }
        let httpReq = HTTP(req)
        httpReq.onFinish = completionHandler
        return httpReq
    }
    
    /**
     Set the global auth handler
     */
    open class func globalAuth(_ handler: ((URLAuthenticationChallenge) -> URLCredential?)?) {
        DelegateManager.sharedInstance.auth = handler
    }
    
    /**
     Set the global security handler
     */
    open class func globalSecurity(_ security: HTTPSecurity?) {
        DelegateManager.sharedInstance.security = security
    }
    
    /**
     Set the global request handler
     */
    open class func globalRequest(_ handler: ((URLRequest) -> Void)?) {
        DelegateManager.sharedInstance.requestHandler = handler
    }
}

extension HTTP {
    static func == (left: HTTP, right: HTTP) -> Bool {
        return left.task.taskIdentifier == right.task.taskIdentifier
    }
    
    static func != (left: HTTP, right: HTTP) -> Bool {
        return !(left == right)
    }
}

/**
 Absorb all the delegates methods of NSURLSession and forwards them to pretty closures.
 This is basically the sin eater for NSURLSession.
 */
public class DelegateManager: NSObject, URLSessionDataDelegate, URLSessionDownloadDelegate {
    //the singleton to handle delegate needs of NSURLSession
    static let sharedInstance = DelegateManager()
    
    /// this is for global authenication handling
    var auth:((URLAuthenticationChallenge) -> URLCredential?)?
    
    ///This is for global SSL pinning
    var security: HTTPSecurity?
    
    /// this is for global request handling
    var requestHandler:((URLRequest) -> Void)?
    
    var taskMap = Dictionary<Int,Response>()
    //"install" a task by adding the task to the map and setting the completion handler
    func addTask(_ task: URLSessionTask, completionHandler:@escaping ((Response) -> Void)) {
        addResponseForTask(task)
        if let resp = responseForTask(task) {
            resp.completionHandler = completionHandler
        }
    }
    
    //"remove" a task by removing the task from the map
    func removeTask(_ task: URLSessionTask) {
        taskMap.removeValue(forKey: task.taskIdentifier)
    }
    
    //add the response task
    func addResponseForTask(_ task: URLSessionTask) {
        if taskMap[task.taskIdentifier] == nil {
            taskMap[task.taskIdentifier] = Response()
        }
    }
    //get the response object for the task
    func responseForTask(_ task: URLSessionTask) -> Response? {
        return taskMap[task.taskIdentifier]
    }
    
    //handle getting data
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        addResponseForTask(dataTask)
        guard let resp = responseForTask(dataTask) else { return }
        resp.collectData.append(data)
        if resp.progressHandler != nil { //don't want the extra cycles for no reason
            guard let taskResp = dataTask.response else { return }
            progressHandler(resp, expectedLength: taskResp.expectedContentLength, currentLength: Int64(resp.collectData.length))
        }
    }
    
    //handle task finishing
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let resp = responseForTask(task) else { return }
        resp.error = error as NSError?
        if let hresponse = task.response as? HTTPURLResponse {
            resp.headers = hresponse.allHeaderFields as? Dictionary<String,String>
            resp.mimeType = hresponse.mimeType
            resp.suggestedFilename = hresponse.suggestedFilename
            resp.statusCode = hresponse.statusCode
            resp.URL = hresponse.url
        }
        if let code = resp.statusCode, code > 299 {
            resp.error = createError(code)
        }
        if let handler = resp.completionHandler {
            handler(resp)
        }
        removeTask(task)
    }
    
    //handle authenication
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        var sec = security
        var au = auth
        if let resp = responseForTask(task) {
            if let s = resp.security {
                sec = s
            }
            if let a = resp.auth {
                au = a
            }
        }
        if let sec = sec , challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let space = challenge.protectionSpace
            if let trust = space.serverTrust {
                if sec.isValid(trust, domain: space.host) {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                    return
                }
            }
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
            
        } else if let a = au {
            let cred = a(challenge)
            if let c = cred {
                completionHandler(.useCredential, c)
                return
            }
            completionHandler(.rejectProtectionSpace, nil)
            return
        }
        completionHandler(.performDefaultHandling, nil)
    }
    
    //upload progress
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let resp = responseForTask(task) else { return }
        progressHandler(resp, expectedLength: totalBytesExpectedToSend, currentLength: totalBytesSent)
    }
    
    //download progress
    public func urlSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard let resp = responseForTask(downloadTask) else { return }
        progressHandler(resp, expectedLength: totalBytesExpectedToWrite, currentLength: totalBytesWritten)
    }
    
    //handle download task
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let resp = responseForTask(downloadTask) else { return }
        guard let handler = resp.downloadHandler else { return }
        handler(resp, location)
    }
    
    //handle progress
    public func progressHandler(_ response: Response, expectedLength: Int64, currentLength: Int64) {
        guard let handler = response.progressHandler else { return }
        let slice = Float(1.0)/Float(expectedLength)
        handler(slice*Float(currentLength))
    }
    
    /**
     Create an error for response you probably don't want (400-500 HTTP responses for example).
     
     -parameter code: Code for error.
     
     -returns An NSError.
     */
    fileprivate func createError(_ code: Int) -> NSError {
        let text = HTTPStatusCode(statusCode: code).statusDescription
        return NSError(domain: "HTTP", code: code, userInfo: [NSLocalizedDescriptionKey: text])
    }
}

/**
 Handles providing singletons of NSURLSession.
 */
public class SharedSession {
    public static let defaultSession = URLSession(configuration: URLSessionConfiguration.default,
                                                  delegate: DelegateManager.sharedInstance, delegateQueue: nil)
    static let ephemeralSession = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                             delegate: DelegateManager.sharedInstance, delegateQueue: nil)
}


/**
 Bare bones queue to manage HTTP Requests
 */
open class HTTPQueue {
    public var maxSimultaneousRequest = 5
    var queue = [HTTP]()
    let mutex = NSLock()
    var activeReq = [Int: HTTP]()
    var finishedHandler: (() -> Void)?
    
    public init(maxSimultaneousRequest: Int) {
        self.maxSimultaneousRequest = maxSimultaneousRequest
    }
    
    open func add(request: URLRequest) {
        add(http: HTTP(request))
    }
    
    open func add(http: HTTP) {
        var doWork = false
        mutex.lock()
        queue.append(http)
        if activeReq.count < maxSimultaneousRequest {
            doWork = true
        }
        mutex.unlock()
        if doWork {
            run()
        }
    }
    
    open func finished(queue: DispatchQueue = DispatchQueue.main, completionHandler: @escaping (() -> Void)) {
        finishedHandler = completionHandler
    }
    
    func run() {
        guard let http = nextItem() else {
            mutex.lock()
            let count = activeReq.count
            mutex.unlock()
            if count == 0 {
                finishedHandler?()
            }
            return
        }
        let handler = http.onFinish
        http.run {[weak self] (response) in
            handler?(response)
            self?.mutex.lock()
            self?.activeReq.removeValue(forKey: http.task.taskIdentifier)
            self?.mutex.unlock()
            self?.run()
        }
    }
    
    func nextItem() -> HTTP? {
        mutex.lock()
        if queue.count == 0 {
            mutex.unlock()
            return nil
        }
        let next = queue.removeFirst()
        activeReq[next.task.taskIdentifier] = next
        mutex.unlock()
        return next
    }
}
//
//  HTTPSecurity.swift
//  SwiftHTTP
//
//  Created by Dalton Cherry on 5/16/15.
//  Copyright (c) 2015 Vluxe. All rights reserved.
//

import Foundation
import Security

open class SSLCert {
    var certData: Data?
    var key: SecKey?
    
    /**
     Designated init for certificates
     
     - parameter data: is the binary data of the certificate
     
     - returns: a representation security object to be used with
     */
    public init(data: Data) {
        self.certData = data
    }
    
    /**
     Designated init for public keys
     
     - parameter key: is the public key to be used
     
     - returns: a representation security object to be used with
     */
    public init(key: SecKey) {
        self.key = key
    }
}

open class HTTPSecurity {
    open var validatedDN = true //should the domain name be validated?
    
    var isReady = false //is the key processing done?
    var certificates: [Data]? //the certificates
    var pubKeys: [SecKey]? //the public keys
    var usePublicKeys = false //use public keys or certificate validation?
    
    /**
     Use certs from main app bundle
     
     - parameter usePublicKeys: is to specific if the publicKeys or certificates should be used for SSL pinning validation
     
     - returns: a representation security object to be used with
     */
    public convenience init(usePublicKeys: Bool = false) {
        let paths = Bundle.main.paths(forResourcesOfType: "cer", inDirectory: ".")
        var collect = Array<SSLCert>()
        for path in paths {
            if let d = try? Data(contentsOf: URL(fileURLWithPath: path as String)) {
                collect.append(SSLCert(data: d))
            }
        }
        self.init(certs:collect, usePublicKeys: usePublicKeys)
    }
    
    /**
     Designated init
     
     - parameter keys: is the certificates or public keys to use
     - parameter usePublicKeys: is to specific if the publicKeys or certificates should be used for SSL pinning validation
     
     - returns: a representation security object to be used with
     */
    public init(certs: [SSLCert], usePublicKeys: Bool) {
        self.usePublicKeys = usePublicKeys
        
        if self.usePublicKeys {
            DispatchQueue.global().async {
                var collect = Array<SecKey>()
                for cert in certs {
                    if let data = cert.certData , cert.key == nil  {
                        cert.key = self.extractPublicKey(data)
                    }
                    if let k = cert.key {
                        collect.append(k)
                    }
                }
                self.pubKeys = collect
                self.isReady = true
            }
        } else {
            var collect = Array<Data>()
            for cert in certs {
                if let d = cert.certData {
                    collect.append(d)
                }
            }
            self.certificates = collect
            self.isReady = true
        }
    }
    
    /**
     Valid the trust and domain name.
     
     - parameter trust: is the serverTrust to validate
     - parameter domain: is the CN domain to validate
     
     - returns: if the key was successfully validated
     */
    open func isValid(_ trust: SecTrust, domain: String?) -> Bool {
        
        var tries = 0
        while(!self.isReady) {
            usleep(1000)
            tries += 1
            if tries > 5 {
                return false //doesn't appear it is going to ever be ready...
            }
        }
        var policy: SecPolicy
        if self.validatedDN {
            policy = SecPolicyCreateSSL(true, domain as CFString?)
        } else {
            policy = SecPolicyCreateBasicX509()
        }
        SecTrustSetPolicies(trust,policy)
        if self.usePublicKeys {
            if let keys = self.pubKeys {
                var trustedCount = 0
                let serverPubKeys = publicKeyChainForTrust(trust)
                for serverKey in serverPubKeys as [AnyObject] {
                    for key in keys as [AnyObject] {
                        if serverKey.isEqual(key) {
                            trustedCount += 1
                            break
                        }
                    }
                }
                if trustedCount == serverPubKeys.count {
                    return true
                }
            }
        } else if let certs = self.certificates {
            let serverCerts = certificateChainForTrust(trust)
            var collect = Array<SecCertificate>()
            for cert in certs {
                collect.append(SecCertificateCreateWithData(nil,cert as CFData)!)
            }
            SecTrustSetAnchorCertificates(trust,collect as CFArray)
            var result: SecTrustResultType = SecTrustResultType(rawValue: UInt32(0))!
            SecTrustEvaluate(trust,&result)
            if result == SecTrustResultType.unspecified || result == SecTrustResultType.proceed {
                var trustedCount = 0
                for serverCert in serverCerts {
                    for cert in certs {
                        if cert == serverCert {
                            trustedCount += 1
                            break
                        }
                    }
                }
                if trustedCount == serverCerts.count {
                    return true
                }
            }
        }
        return false
    }
    
    /**
     Get the public key from a certificate data
     
     - parameter data: is the certificate to pull the public key from
     
     - returns: a public key
     */
    func extractPublicKey(_ data: Data) -> SecKey? {
        let possibleCert = SecCertificateCreateWithData(nil,data as CFData)
        if let cert = possibleCert {
            return extractPublicKeyFromCert(cert, policy: SecPolicyCreateBasicX509())
        }
        return nil
    }
    
    /**
     Get the public key from a certificate
     
     - parameter data: is the certificate to pull the public key from
     
     - returns: a public key
     */
    func extractPublicKeyFromCert(_ cert: SecCertificate, policy: SecPolicy) -> SecKey? {
        var possibleTrust: SecTrust?
        SecTrustCreateWithCertificates(cert, policy, &possibleTrust)
        if let trust = possibleTrust {
            var result: SecTrustResultType = SecTrustResultType(rawValue: UInt32(0))!
            SecTrustEvaluate(trust, &result)
            return SecTrustCopyPublicKey(trust)
        }
        return nil
    }
    
    /**
     Get the certificate chain for the trust
     
     - parameter trust: is the trust to lookup the certificate chain for
     
     - returns: the certificate chain for the trust
     */
    func certificateChainForTrust(_ trust: SecTrust) -> Array<Data> {
        var collect = Array<Data>()
        for i in 0 ..< SecTrustGetCertificateCount(trust) {
            let cert = SecTrustGetCertificateAtIndex(trust,i)
            collect.append(SecCertificateCopyData(cert!) as Data)
        }
        return collect
    }
    
    /**
     Get the public key chain for the trust
     
     - parameter trust: is the trust to lookup the certificate chain and extract the public keys
     
     - returns: the public keys from the certifcate chain for the trust
     */
    func publicKeyChainForTrust(_ trust: SecTrust) -> Array<SecKey> {
        var collect = Array<SecKey>()
        let policy = SecPolicyCreateBasicX509()
        for i in 0 ..< SecTrustGetCertificateCount(trust) {
            let cert = SecTrustGetCertificateAtIndex(trust,i)
            if let key = extractPublicKeyFromCert(cert!, policy: policy) {
                collect.append(key)
            }
        }
        return collect
    }
}

