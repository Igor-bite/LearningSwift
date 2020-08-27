//
//  DetailViewController.swift
//  Project16
//
//  Created by Игорь Клюжев on 10.08.2020.
//  Copyright © 2020 Игорь Клюжев. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    var urlToLoad: URL?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: urlToLoad!))
    }
    

}
