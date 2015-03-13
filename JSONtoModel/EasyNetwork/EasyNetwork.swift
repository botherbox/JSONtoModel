//
//  EasyNetwork.swift
//  EasyNetwork
//
//  Created by BotherBox on 15/3/3.
//  Copyright (c) 2015年 sz. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

public class EasyNetwork {
    
    public typealias Completion = (data: AnyObject?, error: NSError?) -> Void
    
    public func requestJSONWithURL(urlString: String, method: HTTPMethod, params: [String: String]?, completion:Completion) {
        
        // 根据请求方法和请求参数字符串生成NSURLRequest
        if let request = creatRequest(urlString, method: method, params: params) {
            //
            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                
                // 如果有错误直接返回
                if error != nil {
                    completion(data: nil, error: error)
                    return
                }
                
                var jsonError: NSError?
                let result: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &jsonError)
                
                // 如果反序列化失败
                if result == nil {
                    let error = NSError(domain: EasyNetwork.errorDomain, code: 1, userInfo: ["error": "反序列化失败", "error_json": jsonError!])
                    completion(data: nil, error: error)
                } else {
                    dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
                        completion(data: result, error: nil)
                    })
                }
                
            }).resume()
            
            // 请求成功，不继续往下走
            return
        }
        
        // 请求失败
        let error = NSError(domain: EasyNetwork.errorDomain, code: -1, userInfo: ["errorMsg": "请求失败"])
        completion(data: nil, error: error)
        
    }
    
    /// 生成请求对象
    func creatRequest(urlString: String, method: HTTPMethod, params: [String: String]?) -> NSURLRequest? {
        
        if urlString.isEmpty {
            return nil
        }
        
        var request: NSURLRequest?
        var urlStrM = urlString

        if method == HTTPMethod.GET {
//            var url = NSURL(string: urlString + "?" + parseParams(params)!)
            
            if let queryStr = parseParams(params) {
                urlStrM += "?" + queryStr
            }
            
            request = NSURLRequest(URL: NSURL(string: urlStrM)!)
        } else if method == HTTPMethod.POST { // POST请求
            
            // 如果请求参数不为空
            if let queryStr = parseParams(params) {
                let requestM = NSMutableURLRequest(URL: NSURL(string: urlString)!)
                requestM.HTTPMethod = method.rawValue
                requestM.HTTPBody = queryStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                request = requestM
            }
        }
        
        return request
    }
    
    // 解析参数
    func parseParams(params: [String: String]?) -> String? {
        if params == nil || params!.isEmpty {
            return nil
        }
        
        var tmpArr = [String]()
        for (k, v) in params! {
            tmpArr.append("\(k)=\(v)")
        }
        
        return join("&", tmpArr)
    }
    
    static let errorDomain = "com.botherbox.EasyNetwork"
    
    /// Construction Method
    public init() {}
}