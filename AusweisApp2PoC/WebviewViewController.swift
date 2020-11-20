//
//  WebviewViewController.swift
//  AusweisApp2PoC
//
//  Created by Niroshan Maheswaran on 29.11.20.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController {
    
    // MARK: - Public properties
    
    /// URL from AusweissApp2SDK after successful authentication.
    public var url: URL?
    
    // MARK: - Private properties
    
    private var webview: WKWebView?
    
    override func loadView() {
        webview = WKWebView()
        webview?.navigationDelegate = self
        view = webview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let requestURL = url else { return }
        webview?.load(URLRequest(url: requestURL))
    }
}

// MARK: - WKNavigationDelegate

extension WebviewViewController: WKNavigationDelegate {}
