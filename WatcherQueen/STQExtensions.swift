//
//  STQExtensions.swift
//  WatcherQueen
//
//  Created by Fabio Innocente on 8/30/16.
//  Copyright © 2016 Fabio Innocente. All rights reserved.
//

import Foundation

extension Double {
    func accurate(_ decimals:Int) -> Double {
        return (floor(self/(1/pow(10.0,Double(decimals)))) * 0.01) // format decimals        
    }
}
