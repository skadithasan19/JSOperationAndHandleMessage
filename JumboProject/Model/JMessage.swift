//
//  JMessage.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/20/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import Foundation

// Model for the message
struct JMessage {
    var id:Int
    var message:String
    var progress:Int
    
    init(json:[String:Any]) {
        id = json["id"] as? Int ?? 0
        message = json["message"] as? String ?? ""
        progress = json["progress"] as? Int ?? 0
    }
}
