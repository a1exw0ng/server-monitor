//
//  STQJob.swift
//  WatcherQueen
//
//  Created by Fabio Innocente on 8/22/16.
//  Copyright © 2016 Fabio Innocente. All rights reserved.
//

import Foundation

protocol STQJobProtocol {
    func execute(_ completionHandler: STQErrorCompletion?)
}

typealias STQJobStatus = STQServiceStatus

/// NOTE: Here I implemented command pattern.
///       This class below is used to generalize all kinds of jobs
///       that going to be executed (i.e: parse tests, database tests
///       and whatever could be useful and testable).

class STQJob : STQJobProtocol {
    var name : String = "Unknown"
    var status : STQJobStatus = .unknown
    
    func execute(_ completionHandler: STQErrorCompletion?) {
        preconditionFailure("Execute method needs to be implemented.")
    }
}
