
//
//  CPAOnlinePaymentVc.swift
//  CPA
//
//  Created by Ahmed Durrani on 03/08/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPAOnlinePaymentVc: UIViewController , UIWebViewDelegate , NVActivityIndicatorViewable {
    @IBOutlet var webLoadRequest: UIWebView!
    let size = CGSize(width: 60, height: 60)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        webLoadRequest.delegate = self
        
        if let url = URL(string: "https://fattpay.com/#/pay/cpasolutionsinc") {
            let request = URLRequest(url: url)
            webLoadRequest.loadRequest(request)
            
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLeftMenu_Pressed(_ sender: UIButton) {
        self.revealController.show(self.revealController.leftViewController)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)

//        indicatorView.startAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
//        indicatorView.stopAnimating()
        self.stopAnimating()

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
//        indicatorView.stopAnimating()
        self.stopAnimating()

        
    }


}
