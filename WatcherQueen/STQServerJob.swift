//
//  STQServerJob.swift
//  WatcherQueen
//
//  Created by Fabio Innocente on 8/22/16.
//  Copyright © 2016 Fabio Innocente. All rights reserved.
//

import Foundation

class STQServerJob: STQJob {
    override init(){
        super.init()
        self.name = "New job"
    }
    
    override func execute(_ completionHandler: STQErrorCompletion?) {
        // TODO: implement here your new job
    }
}
