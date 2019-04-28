//
//  HttpServerManager.swift
//  hownet
//
//  Created by 张越 on 2019/3/21.
//  Copyright © 2019 张越. All rights reserved.
//

import UIKit

class HttpServerManager: NSObject {
    
    func getServerData(_ url:String, _ complete: @escaping (_ dic:[String:Any]) -> ()) {
        
        var request: URLRequest? = nil
        if let url = URL(string: url) {
            request = URLRequest(url: url)
        }
        request?.timeoutInterval = 10
        request?.httpMethod = "GET"
        
        let session = URLSession.shared
        let sessionDataTask: URLSessionDataTask = session.dataTask(with: request!) { (data:Data?, response, error) in
            var responseData: Any? = nil
            responseData = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves)
            complete(responseData as! [String : Any])
        }
        sessionDataTask.resume()
    }

}
