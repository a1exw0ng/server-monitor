//
//  STQServiceDetailsViewController.swift
//  WatcherQueen
//
//  Created by Fabio Innocente on 8/19/16.
//  Copyright © 2016 Fabio Innocente. All rights reserved.
//

import Foundation
import UIKit

class STQServiceDetailsViewController: UIViewController {
    var service : STQService!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var memoryUsageLabel: UILabel!
    @IBOutlet weak var cpuUsageLabel: UILabel!
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var lastRefreshTimeLabel: UILabel!
    
    let JobCellIdentifier = "JobCell"
    
    enum StatusEmoji : String {
        case online     = "✅"
        case offline    = "❌"
        case warning    = "⚠️"
        case unknown    = "❔"
    }
    
    override func viewDidLoad() {
        refresh()
    }
    
    private func update(){
        // Update name of service
        serviceTitleLabel.text = service.name
        
        // Update memory usage of service
        let memoryUsage = ByteCountFormatter.string(fromByteCount: Int64(service.memoryUsage), countStyle: .memory)
        self.memoryUsageLabel.text = "📼\(memoryUsage)"
        
        // Update cpu usage of service
        self.cpuUsageLabel.text = "⏲\(service.cpuUsage.accurate(2) * 100)%"
    }
        
    private func executeJobs(){
        for (index,job) in service.jobs.enumerated() {
            startLoader(rowAt: index)
            job.execute({ (_) in
                self.jobsTableView.reloadData()
            })
        }
    }
    
    private func refresh(){
        update()
        executeJobs()
        self.lastRefreshTimeLabel.text = "\(Date())"
    }
    
    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        refresh()
    }
}

// MARK :- TableView Delegates

extension STQServiceDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.jobs.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Jobs"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: JobCellIdentifier) as? STQJobCell {
            let index = indexPath.item
            cell.nameLabel.text = service.jobs[index].name
            
            switch service.jobs[index].status.rawValue {
            case STQServiceStatus.online.rawValue :
                cell.statusLabel.text = StatusEmoji.online.rawValue
                break
            case STQServiceStatus.offline.rawValue :
                cell.statusLabel.text = StatusEmoji.offline.rawValue
                break
            case STQServiceStatus.warning.rawValue :
                cell.statusLabel.text = StatusEmoji.warning.rawValue
                break
            default:
                cell.statusLabel.text = StatusEmoji.unknown.rawValue
                break
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func startLoader(rowAt index: Int){
        if let cell = jobsTableView.cellForRow(at: IndexPath(item: index, section: 0)) as? STQJobCell {
            cell.statusLabel.text = "🔄"
        }
    }
}
