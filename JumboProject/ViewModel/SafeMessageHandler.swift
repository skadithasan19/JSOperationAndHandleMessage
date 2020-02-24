//
//  SafeMessageHandler.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/20/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import Foundation
import WebKit

// Created Just to Avoid Memory leak
class SafeMessageHandler : NSObject, WKScriptMessageHandler {
    weak var delegate : WKScriptMessageHandler?
    init(delegate:WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
}
