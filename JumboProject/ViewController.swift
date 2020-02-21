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
     
    var mainWebView = WKWebView()

    var messages:[JMessage] = []
   
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let stri = "<head><head><html><body><h1></h1></body></html>"
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
    @objc func startOperation(){
        let randomNum = Int(arc4random_uniform(UInt32(100 + 1))) /// Added for Testing
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
            print("Jumbo Message body - \(message.body)")
            if let str = message.body as? String, let messageDictionary = str.convertToDictionary() {
                self.messages.append(JMessage(json: messageDictionary))
            }
            statusTable.reloadData()
            statusTable.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
         }
    }
}
 
//// Displaying Message in TableView
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StatusViewCell
        let message = messages[indexPath.row]
        cell.idLabel?.text = "ID: \(message.id)"
        cell.progressLabel?.text = "Progress: \(message.progress)"
        cell.messageLabel?.text = "Status: \(message.message)"
        return cell
    }
}

extension ViewController:WKNavigationDelegate, WKUIDelegate {
    /// Starting Operation when WKWebView loading Successfully
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        startOperation()
    }
}

