//
//  CPStartVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 19/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPStartVC: UIViewController, NVActivityIndicatorViewable {
    let size = CGSize(width: 60, height: 60)

    @IBOutlet weak var btnSignUp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        WAShareHelper.setBorderAndCornerRadius(layer: btnSignUp.layer, width: 2.0, radius: 0.0, color: UIColor(red: 127/255.0, green: 160/255.0, blue: 192/255.0, alpha: 1.0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verifyAutoLogin()
    }
    
    func configureSizeOfViews(){
        NotificationCenter.default.addObserver(self, selector: #selector(CPStartVC.verifyAutoLogin), name: Notification.Name(rawValue: "Auto"), object: nil)
    }
    
    @objc func verifyAutoLogin() {
        //        var phone = UserDefaults.standard.string(forKey: "phone")
        let pass = UserDefaults.standard.string(forKey: "password")
        let email = UserDefaults.standard.string(forKey: "email")
        let idOfUser = UserDefaults.standard.integer(forKey: "id")
        
        
        if idOfUser == 0  {
            
        } else {
            

            let loginParam = [ "email"         : email! ,
                               "password"      : pass! ,
                               
                               ] as [String : Any]
            startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
            
            WebServiceManager.post(params: loginParam as Dictionary<String, AnyObject>, serviceName: LOGIN, isLoaderShow: true, serviceType: "autologin", modelType: UserResponse.self, success: { (response) in
                self.stopAnimating()
                
                let responseObj = response as! UserResponse
                
                if responseObj.success == true {
                    localUserData = responseObj.data
                    WAShareHelper.goToHomeController(vcIdentifier: "CPClientPortalVC", storyboardName: "Home", navController: self.navigationController!, leftMenuIdentifier: "CPSideMenuVC")
                }else {
                    self.showAlert(title: "Pacific", message: responseObj.message!, controller: self)
                    
                }
            }, fail: { (error) in
                self.showAlert(title: "Error", message: error.localizedDescription, controller: self)
                self.stopAnimating()
                
            }, showHUD: true)
        }
    }
    
    
    @IBAction func btnLogin_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPLoginVC") as? CPLoginVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func btnSignUp_Pressed(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPSignUpVC") as? CPSignUpVC
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    

}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
}

