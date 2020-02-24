//
//  JMessage.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/20/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import Foundation

enum Status:String {
    case started
    case progress
    case success
    case error
    case none
    
}

// Model for the message
struct JMessage {
    var id:Int
    var state:Status
    var progress:Int
    
    init(json:[String:Any]) {
        id = json["id"] as? Int ?? 0
        state = Status(rawValue: json["state"] as? String ?? "") ?? .none
        progress = json["progress"] as? Int ?? 0
    }
}
