//
//  CPSideMenuVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 19/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CPSideMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnClientPortal_Pressed(_ sender: UIButton) {
        WAShareHelper.goToHomeController(vcIdentifier: "CPClientPortalVC", storyboardName: "Home", navController: nil, leftMenuIdentifier: "CPSideMenuVC")

    }
    @IBAction func btnOnlinePayment_Pressed(_ sender: UIButton) {
        WAShareHelper.goToHomeController(vcIdentifier: "CPAOnlinePaymentVc", storyboardName: "Home", navController: nil, leftMenuIdentifier: "CPSideMenuVC")
    }
    
    @IBAction func btnAboutUs_Pressed(_ sender: UIButton) {
        WAShareHelper.goToHomeController(vcIdentifier: "CPAAboutVC", storyboardName: "Home", navController: nil, leftMenuIdentifier: "CPSideMenuVC")

        
    }
    
    @IBAction func btnBlog_Pressed(_ sender: UIButton) {
        WAShareHelper.goToHomeController(vcIdentifier: "WABlogVC", storyboardName: "Home", navController: nil, leftMenuIdentifier: "CPSideMenuVC")

    }
    
    @IBAction func btnSetting_Pressed(_ sender: UIButton) {
        
        WAShareHelper.goToHomeController(vcIdentifier: "CPSettingVC", storyboardName: "Home", navController: nil, leftMenuIdentifier: "CPSideMenuVC")

    }
   

}
