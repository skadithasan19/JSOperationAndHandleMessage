//
//  JMWebViewModel.swift
//  JumboProject
//
//  Created by Hasan, MdAdit on 2/24/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import UIKit
import WebKit

protocol JSWebKitMessageHandler : class {
    func callBackWithJSWebKitMessage(message:JMessage?, error:Error?)
}

class JMWebViewModel:NSObject {
  
    fileprivate var mainWebView:WKWebView!
    
    weak var delegate:JSWebKitMessageHandler?
    
    override init() {
        super.init()
        let webCfg = WKWebViewConfiguration()
        let userController = WKUserContentController()
        userController.add(SafeMessageHandler(delegate: self), name: "jumbo")
        if let scripts = fetchScript() {
            userController.addUserScript(scripts)
        }
        webCfg.preferences.javaScriptEnabled = true
        webCfg.userContentController = userController
        
        mainWebView = WKWebView (frame: .zero, configuration: webCfg)
        let stri = "<head><head><html><body><h1>WKWebview</h1></body></html>"
        mainWebView.loadHTMLString(stri, baseURL: nil)
    }
    
    func getWebView() -> WKWebView? {
        return mainWebView
    }
      
    // Creating JS Script content for the Given URL
    fileprivate func fetchScript() -> WKUserScript? {
      let urlString = "https://jumboassetsv1.blob.core.windows.net/publicfiles/interview_bundle.js"
         guard let myURL = URL(string: urlString) else {
            let error = NSError(domain:"", code:-1, userInfo:[ NSLocalizedDescriptionKey: "Error: \(urlString) doesn't seem to be a valid URL"]) as Error
             delegate?.callBackWithJSWebKitMessage(message: nil, error: error)
             return nil
         }
         
         var jsScript = ""
         
         do {
             jsScript = try String(contentsOf: myURL)
         } catch let error {
             print("Error \(error.localizedDescription)")
            delegate?.callBackWithJSWebKitMessage(message: nil, error: error)
           //  self.presentAlert(withTitle: "Warning", message: error.localizedDescription)
         }
          
         return WKUserScript(source: jsScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
     }
    
    /// Executing java script function
    func evaluateWithJSFunction(count: Int, completion: ((Any?, Error?) -> Void)? = nil) {
        mainWebView.evaluateJavaScript("startOperation(\(count));", completionHandler: completion)
    }
}


extension JMWebViewModel: WKScriptMessageHandler {
    // Showing JS message in Native Tableview UI
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
   
         if(message.name == "jumbo") {
            //print("Jumbo Message body - \(message.body)")
            if let str = message.body as? String, let messageDictionary = str.convertToDictionary() {
                let jMessageObj = JMessage(json: messageDictionary)
                delegate?.callBackWithJSWebKitMessage(message: jMessageObj, error: nil)
                print(messageDictionary)
            }
         }
    }
}
