//
//  CPSignUpVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 19/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPSignUpVC: UIViewController , NVActivityIndicatorViewable{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    let size = CGSize(width: 60, height: 60)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.setLeftPaddingPoints(10)
        txtPassword.setLeftPaddingPoints(10)
        txtFirstName.setLeftPaddingPoints(10)
        txtLastName.setLeftPaddingPoints(10)
        txtPhoneNumber.setLeftPaddingPoints(10)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignUp_Pressed(_ sender: UIButton) {
        let errorMessage = validateRegisterFields()
        if errorMessage == "" {

        let firstNum = "0"
        let phoneNum  =  "\(firstNum)\(txtPhoneNumber.text!)"
        let loginParam =  [ "email"         : txtEmail.text!,
                            "firstname"     : txtFirstName.text! ,
                            "password"      : txtPassword.text! ,
                            "lastname"      : txtLastName.text! ,
                            "mobile"        : phoneNum ,
            
            ] as [String : Any]
            startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
            
            WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: SIGNUP, isLoaderShow: true, serviceType: "Login", modelType: UserResponse.self, success: { (response) in
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
                    self.showAlert(title: "CPA", message: responseObj.message!, controller: self)
                }
            }, fail: { (error) in
                self.stopAnimating()
                
            }, showHUD: true)
        } else {
            
            self.showAlert(title: "CPA", message: errorMessage, controller: self)
            
            
       
    }
        

    }
    
    func isValidName(name: String) -> Bool {
        let decimalCharacters = NSCharacterSet.decimalDigits
        let decimalRange = name.rangeOfCharacter(from: decimalCharacters, options: String.CompareOptions.numeric, range: nil)
        
        if decimalRange != nil {
            return false
        }
        return true
    }
    
    func validate(value: String) -> Bool {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
  
    private func validateRegisterFields() -> String {
//        @IBOutlet weak var txtEmail: UITextField!
//        @IBOutlet weak var txtPassword: UITextField!
//
//        @IBOutlet weak var txtFirstName: UITextField!
//        @IBOutlet weak var txtLastName: UITextField!
//        @IBOutlet weak var txtPhoneNumber: UITextField!
        
        let firstName = txtFirstName.text!
        let lastName = txtLastName.text!
        let phoneNum = txtPhoneNumber.text!

        let userEmail = txtEmail.text!
        let userPassword = txtPassword.text!
        
        var message = ""
        
        //        let str = userEmail
        if (firstName != "") {
            if (isValidName(name: firstName) == false) {
                message = "First Name must be alphabet characters.\n"
            }
        } else {
            message += "Enter First Name.\n"
        }
        
        if (lastName != "") {
            if (isValidName(name: lastName) == false) {
                message = "Last Name must be alphabet characters.\n"
            }
        } else {
            message += "Enter Last Name.\n"
        }
       
//        if self.txtPhoneNumber.text!.count == 0{
//             message = "Phone Number must be alphabet characters.\n"
////            validInput = false
////            self.txtPhoneNum.becomeFirstResponder()
////            self.showAlert(title: "PFD", message: kValidationMessageMissingInput, controller: self)
//
//        }
//
//
//        else if self.txtPhoneNum.text!.count <= kUserNameRequiredLengthForPhone {
//            validInput = false
//            self.txtPhoneNum.becomeFirstResponder()
//            self.showAlert(title: "PFD", message: kValidationMessageMissingInputPhone, controller: self)
//        }
        
//        if validate(value: txtPhoneNumber.text!) == true {
//
//        }
       
        
        if WAShareHelper.isValidEmail(email: userEmail) == false {
            message += "Enter valid email address.\n"
        }
        
        
        if ((userPassword.count) >= kPasswordRequiredLength) {
            if userPassword.contains(" ") == true {
                message += "Password cannot contain spaces.\n"
            }
        } else {
            message += "Use a password that is 5 characters long or more.\n"
        }
        
        
        
        
        return message
    }

}
