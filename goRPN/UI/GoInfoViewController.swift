//
//  GoInfoViewController.swift
//  goRPN
//
//  Created by Joel Perry on 3/4/17.
//  Copyright (c) Joel Perry. All rights reserved.
//  Licensed under the MIT License. See LICENSE file in the project root for full license information.
//

import UIKit

class GoInfoViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        versionLabel.text = versionString
        
        if let path = Bundle.main.path(forResource: "GoInfo", ofType: "html"),
           let html = try? String(contentsOfFile: path) {
            webView.loadHTMLString(html, baseURL: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var versionString: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? ""
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") ?? ""
        return "v\(version) (\(build))"
    }
}

extension GoInfoViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.url, navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(url)
            return false
        }
        return true
    }
}
