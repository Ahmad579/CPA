//
//  CPAResetPasswordVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 31/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPAResetPasswordVC: UIViewController  , NVActivityIndicatorViewable {
    
    @IBOutlet weak var txtPassword: UITextField!
    let size = CGSize(width: 60, height: 60)
    var codeEnter   : String?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func btnNext_Pressed(_ sender: UIButton) {
        if isViewPassedSignValidation() {
            let loginParam =  [ "password"         : txtPassword.text!,
                                "code"             : codeEnter!
                                ] as [String : Any]
            
            startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
            
            WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: RESETPASSWORD, isLoaderShow: true, serviceType: "Reset Password", modelType: UserResponse.self, success: { (response) in
                let responseObj = response as! UserResponse
                self.stopAnimating()
                if responseObj.success == true {
                    
                    self.showAlertViewWithTitle(title: "CPA", message: responseObj.message!, dismissCompletion: {
                        self.navigationController?.popToRootViewController(animated: true)

                    })
                    
                    
                }else {
                    self.showAlert(title: "CPA", message: responseObj.message!, controller: self)
                    
                    
                }
                
            }, fail: { (error) in
                self.stopAnimating()
                
            }, showHUD: true)
            
        }
    }
    
    func isViewPassedSignValidation() -> Bool
    {
        var validInput = true

        if   self.txtPassword.text!.count ==  0 {
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
