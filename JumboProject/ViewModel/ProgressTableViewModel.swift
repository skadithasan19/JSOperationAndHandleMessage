//
//  ProgressTableViewModel.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/24/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import UIKit

class ProgressTableViewModel: NSObject {
    
   fileprivate var groupedMessages = [Int:JMessage]()
 
    func reloadMessages(message:JMessage, statusTable:UITableView ) {
        if groupedMessages.keys.contains(message.id) {
            groupedMessages[message.id] = message
            statusTable.beginUpdates()
            statusTable.reloadRows(at: [IndexPath(row: message.id - 1, section: 0)], with: .automatic)
            statusTable.endUpdates()
        } else {
            groupedMessages[message.id] = message
            statusTable.beginUpdates()
            statusTable.insertRows(at: [IndexPath(row: message.id - 1, section: 0)], with: .automatic)
            statusTable.endUpdates()
        }
    }
}



 
//// Displaying Progress in TableView
extension ProgressTableViewModel: UITableViewDataSource,UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMessages.keys.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StatusViewCell
        let key = groupedMessages.keys.compactMap({ $0 }).sorted()[indexPath.row]
        if let message = groupedMessages[key] {
            let progressVal = message.state == .success ? 1.0 : Float(message.progress)/Float(100)
            cell.idLabel?.text = "ID: \(message.id)"
            cell.progressSlider.progress = progressVal
            
            if message.state == .none {
                cell.messageLabel?.text = "Currently in Progress"
            } else if message.state == .success {
                cell.messageLabel?.text = "Successful Operation!"
            } else if message.state == .error {
                cell.messageLabel?.text = "Operation Failed!"
            }
         
        }
        return cell
    }
}
