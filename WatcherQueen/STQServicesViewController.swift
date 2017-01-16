//
//  ViewController.swift
//  WatcherQueen
//
//  Created by Fabio Innocente on 8/18/16.
//  Copyright © 2016 Fabio Innocente. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit

class STQServicesViewController: UIViewController {

    @IBOutlet weak var connectionCheckLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var lastRefreshTimeLabel: UILabel!
    @IBOutlet weak var servicesTable: UITableView!
    
    @IBOutlet weak var freeMemoryLabel: UILabel!
    @IBOutlet weak var cpuUsage: UILabel!
    @IBOutlet weak var uptimeLabel: UILabel!
    @IBOutlet weak var connectionsLabel: UILabel!
    
    enum StatusEmoji : String {
        case online     = "✅"
        case offline    = "❌"
        case warning    = "⚠️"
        case unknown    = "❔"
    }
    
    let serviceDetailSegueIdentifier = "ServiceDetails"
    
    var server = STQServer.sharedInstance
    var selectedServiceIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavbar()
    }
    
    func configureNavbar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .compact)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    @IBAction func tapRefreshButton(_ sender: AnyObject) {
        checkServicesAndServerStatus()
    }
    
    func checkServicesAndServerStatus(){
        connectionCheckLabel.text = "Connecting..."
        
        server
            .load()
            .then { server -> Void in
                self.update()
            }
            .catch { (error) in
                self.fail()
            }
            .always {
                self.servicesTable.reloadData()
            }
    }
    
    private func update(){
        // Update Last Refresh time
        self.lastRefreshTimeLabel.text = "\(Date())"
        
        // Update Server's uptime
        let uptime = Date(timeIntervalSince1970:  TimeInterval(server.uptime))
        let upDays = Calendar.current.component(.day, from: uptime)
        self.uptimeLabel.text = "🏆\n\(upDays)d"
        
        // Update Server's free memory
        let freeMBMemory = ByteCountFormatter.string(fromByteCount: Int64(server.freeMemory), countStyle: .memory)
        self.freeMemoryLabel.text = "📼\n\(freeMBMemory)"
        
        // Update Server's cpuUsage
        self.cpuUsage.text = "⏲\n\(server.cpuUsage.accurate(2) * 100)%"
        
        // Update Server's connections (note: waiting for pm2 configuration in server-side)
        // self.connectionsLabel.text = "😀\n\(mainService.connections)"
         self.connectionsLabel.text = "😀\n🛠"
        
        // Update Server's state
        self.connectionCheckLabel.text = "Online ✅"
    }
    
    private func fail(){
        // Update Server's state
        self.connectionCheckLabel.text = "Offline ❌"
        
        // Erase infos
        self.uptimeLabel.text = "🏆\n--"
        self.freeMemoryLabel.text = "📼\n--"
        self.cpuUsage.text = "⏲\n--"
    }
}

extension STQServicesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return server.services.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell") as? STQServiceCell {
            let index = indexPath.item
            let service = server.services[index]
            cell.serviceNameLabel.text = service.name
            switch service.status.rawValue {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedServiceIndex = indexPath.item
        performSegue(withIdentifier: serviceDetailSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? STQServiceDetailsViewController {
            vc.service = server.services[selectedServiceIndex]
        }
    }
}
