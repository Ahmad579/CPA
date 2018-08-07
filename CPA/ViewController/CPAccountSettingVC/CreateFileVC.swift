//
//  CreateFileVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 31/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CreateFileVC: UIViewController , NVActivityIndicatorViewable {
    let size = CGSize(width: 60, height: 60)
    var responseObj: UserResponse?
    @IBOutlet weak var txtDocumentName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtDocumentName.setLeftPaddingPoints(10)
    }
    
    @IBAction func btnCreateFile_Pressed(_ sender: UIButton) {
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        let userId = localUserData.id
        
        let loginParam =  [ "userid"                        : "\(userId!)",
                             "name"                         :  txtDocumentName.text!
                            
                           
                            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: CREATEFOLDER, isLoaderShow: true, serviceType: "All folder", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "verifyDocument"), object: nil, userInfo: nil)

                })
            } else {
                
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "CPA", message: error.description, controller: self)
        }, showHUD: true)
    }
    
   
    
    @IBAction func btnCross_Pressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

  

}
