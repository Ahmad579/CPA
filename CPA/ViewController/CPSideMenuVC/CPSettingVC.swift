//
//  CPSettingVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 31/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CPSettingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    @IBAction func btnLeft_MenuPressed(_ sender: UIButton) {
        self.revealController.show(self.revealController.leftViewController)
    }
    
    @IBAction func btnAccountSetting_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPAccountSettingVC") as? CPAccountSettingVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func btnChangePassword_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPAChangePassVC") as? CPAChangePassVC
        self.navigationController?.pushViewController(vc!, animated: true)

        
    }
    
    @IBAction func btnEmailPreferrence_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPAEmailPreferenceVC") as? CPAEmailPreferenceVC
        self.navigationController?.pushViewController(vc!, animated: true)

        
    }

    @IBAction func btnPaymentMethod_Pressed(_ sender: UIButton) {
        
    }
    
    @IBAction func btnContactUs_Pressed(_ sender: UIButton) {
        
    }
    
    @IBAction func btnLogout_Pressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        UserDefaults.standard.set(nil  , forKey : "id")
        UserDefaults.standard.set(nil  , forKey : "email")
        UserDefaults.standard.set(nil  , forKey : "password")
        localUserData = nil
        UIApplication.shared.keyWindow?.rootViewController = vc
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
