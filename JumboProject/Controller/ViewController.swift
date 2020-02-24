//
//  ViewController.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/20/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import UIKit
import WebKit
import JavaScriptCore

class ViewController: UIViewController {
     
    var totalNunberOfRunningOperationCounter = 1
    
    var progressViewModel = ProgressTableViewModel()
   
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var statusTable: UITableView!

    var webView = JMWebViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let mainWebView = webView.getWebView() else { return }
        webView.delegate = self
        stackView.addArrangedSubview(mainWebView)
        
        mainWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainWebView,
                           attribute: NSLayoutConstraint.Attribute.height,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: nil,
                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                           multiplier: 1,
                           constant: 100).isActive = true   // Setting up height constraits
        
        /// Setting up view model datasource and delegate
        statusTable.dataSource = progressViewModel
        statusTable.delegate = progressViewModel
        
        statusTable.rowHeight = UITableView.automaticDimension
        statusTable.estimatedRowHeight = 55
        title = "Jumbo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add New", style: .plain, target: self, action: #selector(startOperation))
    }
    
    // Call startOperation from native controls
    @objc func startOperation(){
        webView.evaluateWithJSFunction(count: totalNunberOfRunningOperationCounter)
        totalNunberOfRunningOperationCounter = totalNunberOfRunningOperationCounter + 1
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // Added In case we have memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("**** MEMORY WARNING! ****")
        webView.getWebView()?.reload()
    }
}

extension ViewController: JSWebKitMessageHandler {
    func callBackWithJSWebKitMessage(message: JMessage?, error: Error?) {
        navigationItem.rightBarButtonItem?.isEnabled = true
        guard let message = message else {
            self.presentAlert(withTitle: "Warning", message: error?.localizedDescription ?? "")
            return
        }
        progressViewModel.reloadMessages(message: message, statusTable: statusTable)
    }
}


 
