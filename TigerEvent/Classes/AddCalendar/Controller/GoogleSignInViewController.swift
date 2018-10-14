//
//  GoogleSignInViewController.swift
//  TigerEvent Login
//
//  Created by linChunbin on 10/13/18.
//  Copyright © 2018 clpk8. All rights reserved.
//

import UIKit
import WebKit

class GoogleSignInViewController: UIViewController, WKUIDelegate{

    var webView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let googleLoginURL = URL(string:"https://www.google.com")
        let myRequest = URLRequest(url: googleLoginURL!)
        webView.load(myRequest)
        
    }
    

    override func loadView() {
        
        let wenConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: wenConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
