//
//  CPAccountSettingVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 31/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPAccountSettingVC: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    let size = CGSize(width: 60, height: 60)
    var responseObj: UserResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.text = localUserData.email
        txtFirstName.text = localUserData.firstname
        txtLastName.text = localUserData.lastname
        txtPhoneNumber.text = localUserData.mobile
        txtAddress.text = localUserData.address
        txtZipCode.text = localUserData.zip
        
    }
//

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSaveInfo_Pressed(_ sender: UIButton) {
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        let userId = localUserData.id
        let firstNum = "0"
        let phoneNum  =  "\(firstNum)\(txtPhoneNumber.text!)"

        let loginParam =  [ "userid"                        : "\(userId!)",
                            "firstname"                     : txtFirstName.text! ,
                            "lastname"                      : txtLastName.text!,
                            "mobile"                        : phoneNum ,
                             "email"                        : txtEmail.text! ,
                             "address"                      : txtAddress.text! ,
                             "zip"                          : txtZipCode.text!
                          ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: UPDATEPROFILE, isLoaderShow: true, serviceType: "All folder", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.showAlertViewWithTitle(title: "CPC", message: (self.responseObj?.message)!, dismissCompletion: {
                    localUserData = self.responseObj?.updateUser

                })
            } else {
                self.showAlert(title: "CPA", message: (self.responseObj?.message!)!, controller: self)
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "CPA", message: error.description, controller: self)
        }, showHUD: true)    }
    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
  

}
