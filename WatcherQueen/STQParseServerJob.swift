//
//  STQParseServerJob.swift
//  WatcherQueen
//
//  Created by Fabio Innocente on 8/22/16.
//  Copyright © 2016 Fabio Innocente. All rights reserved.
//

import Foundation
import Alamofire

/// It's a Parse job.
/// Inherit it to test any resource by Cloud Code API this way.
class STQParseServerJob: STQJob {
    static let PARSE_APP_ID : String = "yourParseAppID"
    static let PARSE_REST_KEY : String = "yourParseRESTAPIKey"
    
    let baseUrl = "http://yourParseServer"
    let headers : HTTPHeaders = ["X-Parse-Application-Id"      :   "\(PARSE_APP_ID)",
                  "X-Parse-REST-API-Key"        :   "\(PARSE_REST_KEY)",
                  "X-Parse-Revocable-Session"   :   "1"]        
}


/// This job tests Parse authentication service using a powerless user (e.g: "monitor:RIPparse" below).
class STQParseServerAuthJob : STQParseServerJob {
    override init(){
        super.init()
        self.name = "Authentication"
    }
    
    override func execute(_ completionHandler: STQErrorCompletion?) {
        let loginServiceUrl = "\(baseUrl)/login"
        let authParameters : [String:Any]? = ["username":"monitor","password":"RIPparse"]
        
        Alamofire.request(loginServiceUrl, method: .get, parameters: authParameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
                print(response)
                let error = response.result.error
                self.status = (error == nil ? STQJobStatus.online : STQJobStatus.offline)
                completionHandler?(error)
        }        
    }
}
