//
//  STQModelService.swift
//  WatcherQueen
//
//  Created by Fabio Innocente on 8/19/16.
//  Copyright © 2016 Fabio Innocente. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

typealias STQErrorCompletion = (Error?)->()

/// Represents our server
class STQServer {
    
    static let sharedInstance = STQServer() // NOTE: This app was designed for a single server
    
    // Server Information
    var uptime : Int = 0        // hours
    var freeMemory : Int = 0    // bytes
    var cpuUsage : Double = 0   // percentage
    var connections : Int = 0   // integer
    
    let serverURL = "http://yourServer.com"
    
    var services = [STQService]()

    
    /// Load server information
    ///
    /// - Returns: be my guest to try this promises (:
    func load() -> Promise<STQServer> {
        return Promise<STQServer> { success, failure in
            Alamofire.request(serverURL, parameters: nil)
                .responseJSON { response in
                    self.services = []
                    if  let _ = response.response,
                        let pm2Dict = response.result.value as? [String:AnyObject] {
                        self.loadFrom(pm2Dict: pm2Dict)
                        success(self)
                        return
                    }
                    else if let error = response.result.error {
                        failure(error)
                    }
                    else {
                        let unknownError = NSError(domain: "Unknown", code: 99, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                        failure(unknownError)
                    }
            }
        }
    }
    
    /// Load informations from a pm2 dictionary
    ///
    /// - Parameter pm2Dict: pm2 dictionary containing server information
    private func loadFrom(pm2Dict: [String:AnyObject]) {
        let processes = pm2Dict["processes"] as! [AnyObject]
        for process in processes {
            print(process["name"] as! String)
            let service = STQService(dict: process as! [String:AnyObject])
            loadJobs(service)
            services.append(service)
        }
        
        let systemInfo = pm2Dict["system_info"] as! [String:AnyObject]
        let monit = pm2Dict["monit"] as! [String:AnyObject]
        
        self.uptime = systemInfo["uptime"] as! Int
        self.freeMemory = monit["free_mem"] as! Int
        self.cpuUsage = (monit["loadavg"] as! [Double])[0]
    }

    /// Load jobs for service
    ///
    /// - Parameter service: service which needs jobs
    private func loadJobs(_ service: STQService){
        // NOTE: put your services and their jobs below
        switch service.name {
        case "mongo":
            break
        case "parse_server":
            service.jobs.removeAll()
            service.jobs.append(STQParseServerAuthJob())
            break
        case "parse_dashboard":
            break
        default:
            break
        }
    }

}
