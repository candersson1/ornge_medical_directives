//
//  WebViewController.swift
//  Medic Reference
//
//  Created by Charles Trickey on 2019-11-01.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    var colour: String?
    
    var target: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.navigationDelegate = self

        if(target != nil)
        {
            if let url = Bundle.main.url(forResource: target, withExtension: "html")
            {
                webview.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            } else if let url = Bundle.main.url(forResource: target, withExtension: "pdf")
            {
                webview.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }
            /*if let url = Bundle.main.url(forResource: target, withExtension: "html")
            {
                let myRequest = URLRequest(url: url )
                webview.allowsBackForwardNavigationGestures = true
                //webview.load(myRequest)
                webview.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
            }*/
        }
    }
    
}

//MARK: WKNavigationDeligate
extension WebViewController : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    func getHexColour() -> String? {
        if let colour = colour {
            switch colour {
            case "Red" : return "#FF0000"
            case "Green" : return "#00FF00"
            case "Blue" : return "#0000FF"
            default  : return nil
            }
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        colour = "#ff0000"
        
        let css = "ol ol {list-style-type: lower-alpha;}"
        
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
}
