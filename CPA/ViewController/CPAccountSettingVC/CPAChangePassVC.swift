//
//  CPAChangePassVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 31/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPAChangePassVC: UIViewController , NVActivityIndicatorViewable {
    @IBOutlet weak var txtCurrentPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtVerifyNewPass: UITextField!
    let size = CGSize(width: 60, height: 60)
    var responseObj: UserResponse?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveInfo_Pressed(_ sender: UIButton) {
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        let userId = localUserData.id
        let errorMessage = validateRegisterFields()
        
        if errorMessage == "" {

        let loginParam =  [ "userid"                        : "\(userId!)",
                            "current"                       : txtCurrentPassword.text! ,
                            "new"                           : txtNewPassword.text!
            
            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: UPDATEPASSWORD, isLoaderShow: true, serviceType: "All folder", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.showAlertViewWithTitle(title: "CPC", message: (self.responseObj?.message)!, dismissCompletion: {
                    UserDefaults.standard.set(self.txtNewPassword.text! , forKey: "password")

                })
            } else {
                self.showAlert(title: "CPA", message: (self.responseObj?.message!)!, controller: self)
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "CPA", message: error.description, controller: self)
        }, showHUD: true)
        }else {
            self.showAlert(title: "CPA", message: errorMessage, controller: self)
        }
    }
  

    private func validateRegisterFields() -> String {
        let currenPass = txtCurrentPassword.text
        let newPass = txtNewPassword.text
        let confirmPass = txtVerifyNewPass.text!
        var message = ""
        if ((currenPass?.count)! >= 4) {
            if currenPass?.contains(" ") == true {
                message += "Password cannot contain spaces.\n"
            }
        } else {
            message += "Use a password that is 4 characters long or more.\n"
        }
        if ((newPass?.count)! >= 4) {
            if newPass?.contains(" ") == true {
                message += "Password cannot contain spaces.\n"
            }
        } else {
            message += "Use a password that is 4 characters long or more.\n"
        }
        
        if newPass != confirmPass
        {
            message += "Password mismatch"
        }
        
        return message
    }
}
