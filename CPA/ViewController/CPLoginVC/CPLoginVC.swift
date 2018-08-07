//
//  CPLoginVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 19/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPLoginVC: UIViewController , NVActivityIndicatorViewable {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    let size = CGSize(width: 60, height: 60)

    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
     //   txtEmail.text = "ahmaddurranitrg@gmail.com"
     //   txtPassword.text = "12345678"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnForgotPassword_Pressed(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPAForgotPAsswordVC") as? CPAForgotPAsswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnLogin_Pressed(_ sender: UIButton) {
//
        
        if isViewPassedSignValidation() {
            let loginParam =      [ "email"         : txtEmail.text!,
                                  "password"      : txtPassword.text! ,
                                  ] as [String : Any]
            
            startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
            
            WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: LOGIN, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
                let responseObj = response as! UserResponse
                
                self.stopAnimating()
                
                if responseObj.success == true {
                    localUserData = responseObj.data
                    UserDefaults.standard.set(self.txtEmail.text! , forKey: "email")
                    UserDefaults.standard.set(self.txtPassword.text! , forKey: "password")
                    UserDefaults.standard.set(localUserData.id , forKey: "id")
                    
                    WAShareHelper.goToHomeController(vcIdentifier: "CPClientPortalVC", storyboardName: "Home", navController: self.navigationController!, leftMenuIdentifier: "CPSideMenuVC")
                }
                else {
                    self.showAlert(title: "Event", message: responseObj.message!, controller: self)
                }
            }, fail: { (error) in
                self.stopAnimating()
                
            }, showHUD: true)
            
        }
        

    }
    
    @IBAction func btnShow_Pressed(_ sender: UIButton) {
        
    }
    
    func isViewPassedSignValidation() -> Bool
    {
        var validInput = true
        if self.txtEmail.text!.count < kUserNameRequiredLength {
            validInput = false
            self.txtEmail.becomeFirstResponder()
            self.showAlert(title: "CPA", message: kValidationMessageMissingInput, controller: self)
            
        }
        else  if !WAShareHelper.isValidEmail(email: txtEmail.text!) {
            validInput = false
            self.txtEmail.becomeFirstResponder()
            self.showAlert(title: "CPA", message: kValidationEmailInvalidInput, controller: self)
        }
        else if   self.txtPassword.text!.count ==  0 {
            validInput = false
            self.showAlert(title: "CPA", message: KValidationPassword, controller: self)
        }
        else if   self.txtPassword.text!.count < kPasswordRequiredLength {
            validInput = false
            self.txtPassword.becomeFirstResponder()
            self.showAlert(title: "CPA", message: KValidationPassword, controller: self)
        }
        return validInput
    }
    
}


