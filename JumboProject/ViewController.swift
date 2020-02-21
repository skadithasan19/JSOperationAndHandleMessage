//
//  ViewController.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/20/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
     
    let totalNunberOfRunningOperation = 5
    
    var mainWebView = WKWebView()

    var messages:[JMessage] = []
   
    var groupedMessages = [Int:[JMessage]]()
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var statusTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// I have added one table view to show the message from JS to Native UI
        mainWebView = WKWebView (frame: .zero, configuration: webConfig)
        // Delegate to handle navigation of web content
        mainWebView.navigationDelegate = self
        stackView.addArrangedSubview(mainWebView)
        mainWebView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: mainWebView,
                           attribute: NSLayoutConstraint.Attribute.height,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: nil,
                           attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                           multiplier: 1,
                           constant: 100).isActive = true
        statusTable.dataSource = self
        statusTable.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let stri = "<head><head><html><body><h1>WKWebview Loaded</h1></body></html>"
        mainWebView.loadHTMLString(stri, baseURL: nil)
    }
    
    // Setting up web Config for JS and message handler
    var webConfig:WKWebViewConfiguration {
        get {
            let webCfg = WKWebViewConfiguration()
            let userController = WKUserContentController()
            userController.add(SafeMessageHandler(delegate: self), name: "jumbo")
            if let scripts = fetchScript() {
                userController.addUserScript(scripts)
            }
            webCfg.preferences.javaScriptEnabled = true
            webCfg.userContentController = userController;
            return webCfg
        }
    }
    
    // Creating JS Script content for the Given URL
    func fetchScript() -> WKUserScript? {
        let urlString = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
        guard let myURL = URL(string: urlString) else {
            print("Error: \(urlString) doesn't seem to be a valid URL")
            return nil
        }
        
        var jsScript = ""
        
        do {
            jsScript = try String(contentsOf: myURL)
        } catch {
            print("Error")
        }
        return WKUserScript(source: jsScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }
    
    // Call startOperation from native controls
    @objc func startOperation(randomNum:Int){
        evaluateWithJavaScriptFunction(jsExpression: "startOperation(\(randomNum));")
    }
    
    /// Executing java script function
    func evaluateWithJavaScriptFunction(jsExpression: String, completion: ((Any?, Error?) -> Void)? = nil) {
        mainWebView.evaluateJavaScript(jsExpression, completionHandler: completion)
    }
    
    override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         print("**** MEMORY WARNING! ****")
         mainWebView.reload()
     }
}

extension ViewController: WKScriptMessageHandler {
    // Showing JS message in Native Tableview UI
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
         if(message.name == "jumbo") {
            //print("Jumbo Message body - \(message.body)")
            if let str = message.body as? String, let messageDictionary = str.convertToDictionary() {
                self.messages.append(JMessage(json: messageDictionary))
            }
           // statusTable.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
            groupedMessages = messages.categorise({ $0.id })
             
            statusTable.reloadData()
         }
    }
}
 
//// Displaying Message in TableView
extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedMessages.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = groupedMessages.keys.compactMap({ $0 }).sorted()[section]
        let messages = groupedMessages[key]
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = groupedMessages.keys.compactMap({ $0 }).sorted(by: { $0 > $1 })[section]
        return "startOperation(\(key))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StatusViewCell
        let key = groupedMessages.keys.compactMap({ $0 }).sorted()[indexPath.section]
        
        if let messages = groupedMessages[key]?.sorted(by: { $0.progress > $1.progress }) {
            let message = messages[indexPath.row]
            cell.idLabel?.text = "ID: \(message.id)"
            cell.progressLabel?.text = "Progress: \(message.progress)"
            cell.messageLabel?.text = "Status: \(message.message)"
        }
//        let customColour = UIColor(red:   .random(),green: .random(),blue:  .random(), alpha: 1.0)
//        cell.contentView.backgroundColor = customColour
        return cell
    }
}

extension ViewController:WKNavigationDelegate, WKUIDelegate {
    /// Starting Operation when WKWebView loading Successfully
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        for i in 1...totalNunberOfRunningOperation { // Running startOperation Multiple times
            print("Invoked startOperatation(\(i))")
            startOperation(randomNum: i)
        }
    }
}



public extension Sequence {
    func categorise<U : Hashable>(_ key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        var dict: [U:[Iterator.Element]] = [:]
        for el in self {
            let key = key(el)
            if case nil = dict[key]?.append(el) { dict[key] = [el] }
        }
        return dict
    }
}
