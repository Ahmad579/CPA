//
//  CPAEmailPreferenceVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 31/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPAEmailPreferenceVC: UIViewController , NVActivityIndicatorViewable {

    @IBOutlet weak var btnEsignature_Pressed: UIButton!
    @IBOutlet weak var btnClientEmail: UIButton!
    
    @IBOutlet weak var btnAllEmail_Pressed: UIButton!
    let size = CGSize(width: 60, height: 60)
    var responseObj: UserResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  localUserData.client_email == "true"  {
            btnClientEmail.isSelected = true
        } else{
            btnClientEmail.isSelected = false

        }

        if  localUserData.signature_email == "true"  {
            btnEsignature_Pressed.isSelected = true
        } else{
            btnEsignature_Pressed.isSelected = false
            
        }
        
        if  localUserData.all_email == "true"  {
            btnAllEmail_Pressed.isSelected = true
        } else{
            btnAllEmail_Pressed.isSelected = false
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnClientPortalEmail_Pressed(_ sender: UIButton) {
            sender.isSelected = !sender.isSelected
            emailPreference(selectEmail: "client")
    }
    

    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//
    @IBAction func btnEsignature_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        emailPreference(selectEmail: "signature")

    }
    
    @IBAction func btnAllEmail_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        emailPreference(selectEmail: "all")

    }
    
  
    func emailPreference(selectEmail : String) {
     
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        let userId = localUserData.id
        
        
            let loginParam =   [ "userid"                        : "\(userId!)",
                                 "parameter"                       : selectEmail
                               ] as [String : Any]
            
            WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: EMAILPREFERENCE, isLoaderShow: true, serviceType: "Email Preference", modelType: UserResponse.self, success: { (response) in
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
            }, showHUD: true)
        }
        
    }
    

