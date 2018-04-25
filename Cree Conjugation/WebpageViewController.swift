//
//  WebpageViewController.swift
//  Cree Conjugation
//
//  Created by Wolfgang on 2018-02-26.
//  Copyright © 2018 nistosap. All rights reserved.
//

import UIKit

class WebpageViewController: UIViewController, UIWebViewDelegate {
   
    @IBOutlet weak var webView: UIWebView!
    let titleColor = UIColor(red:98/255, green: 152/255, blue:83/255, alpha:1)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        navigationController?.navigationBar.barTintColor = titleColor
        

let localFile = Bundle.main.url(forResource: "home", withExtension: "html")
        webView.delegate = self
        let myRequest = NSURLRequest(url: localFile!)
        webView.loadRequest(myRequest as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            guard let url = request.url else { return true }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.canOpenURL(url)
            }
            return false
        default:
            return true
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
