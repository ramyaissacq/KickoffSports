//
//  WebViewViewController.swift
//  Core Score
//
//  Created by Remya on 10/11/22.
//

import UIKit
import WebKit

class WebViewViewController: BaseViewController {
    @IBOutlet weak var webView:WKWebView!
    
    
   var urlString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
        

        // Do any additional setup after loading the view.
    }
    
    func initialSettings(){
        setBackButton()
        loadUrl()
    }
    

    func loadUrl(){
        if let link = URL(string:urlString){
        let request = URLRequest(url: link)
        webView.load(request)
        }
    }

}
