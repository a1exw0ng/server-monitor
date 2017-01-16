//
//  STQService.swift
//  WatcherQueen
//
//  Created by Fabio Innocente on 8/19/16.
//  Copyright © 2016 Fabio Innocente. All rights reserved.
//

import Foundation


enum STQServiceStatus : String {
    case online
    case warning
    case offline
    case unknown
}

class STQService {
    var name : String!
    var status : STQServiceStatus!
    var uptime : Int!
    var memoryUsage : Int!
    var cpuUsage : Double!
    var jobs = [STQJob]()
    
    convenience init(name: String, status: STQServiceStatus = .unknown, uptime: Int = -1, memoryUsage: Int = -1, cpuUsage: Double = -1){
        self.init()
        self.name = name
        self.status = status
        self.uptime = uptime
        self.memoryUsage = memoryUsage
        self.cpuUsage = cpuUsage
        
    }
    
    convenience init(dict: [String:AnyObject]){
        if  let name = dict["name"] as? String,
            let env = dict["pm2_env"] as? [String:AnyObject],
            let monit = dict["monit"] as? [String:AnyObject] {
            
            if  let status = env["status"] as? String,
                let uptime = env["pm_uptime"] as? Int,
                let memoryUsage = monit["memory"] as? Int,
                let cpuUsage = monit["cpu"] as? Double {
                
                let serviceStatus = STQServiceStatus(rawValue: status)!
                
                self.init(name: name, status: serviceStatus, uptime: uptime, memoryUsage: memoryUsage, cpuUsage: cpuUsage)
            }
            else { self.init(name: "Unknown") }
        }
        else { self.init(name: "Unknown") }
    }
}
