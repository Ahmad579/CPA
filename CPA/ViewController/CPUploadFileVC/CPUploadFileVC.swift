//
//  CPUploadFileVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 30/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import NVActivityIndicatorView

class CPUploadFileVC: UIViewController  , NVActivityIndicatorViewable {
    
    let photoPicker = PhotoPicker()
    var cover_image: UIImage?
    var allFolderList : UserResponse?
    let size = CGSize(width: 60, height: 60)

    @IBOutlet weak var viewOfDocument: UIView!
    @IBOutlet weak var imgOfDocument: UIImageView!
    
    @IBOutlet weak var btnChooseFolder: UIButton!
    
    @IBOutlet weak var btnSentTo: UIButton!
    @IBOutlet weak var txtOfNote: UITextView!
    var userObject: UserResponse?

    
    var idOfSelectedFolder : Int?
    var idOfSelectUser : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        WAShareHelper.setBorderAndCornerRadius(layer: viewOfDocument.layer, width: 1.0, radius: 1.0, color: UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0))
        WAShareHelper.setBorderAndCornerRadius(layer: btnChooseFolder.layer, width: 1.0, radius: 1.0, color: UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0))
        WAShareHelper.setBorderAndCornerRadius(layer: btnSentTo.layer, width: 1.0, radius: 1.0, color: UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0))
        WAShareHelper.setBorderAndCornerRadius(layer: txtOfNote.layer, width: 1.0, radius: 1.0, color: UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0))


        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(CPUploadFileVC.imageTappedForDp(img:)))
        imgOfDocument.isUserInteractionEnabled = true
        imgOfDocument.addGestureRecognizer(tapGestureRecognizerforDp)
        txtOfNote.placeholder = "Comment"
        getAllUser()
        

        // Do any additional setup after loading the view.
    }
    
    private func getAllUser() {
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)

        WebServiceManager.get(params: nil, serviceName: ALLUSERLIST, serviceType: "All User List", modelType: UserResponse.self, success: { (response) in
            self.stopAnimating()
            self.userObject = (response as! UserResponse)
            if self.userObject?.success == true {
                
            } else {
                self.showAlert(title: "CPA", message: (self.userObject?.message!)!, controller: self)
            }
            
        }) { (error) in
            self.stopAnimating()
            
        }
    }
    
    @objc func imageTappedForDp(img: AnyObject) {
        photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self, successBlock: { (orignal, edited) in
            self.imgOfDocument.image = orignal
            self.cover_image = orignal
        })
        
    }
    
    @IBAction func btnSelectFolder_Pressed(_ sender: UIButton) {
        
        var allCategoriesList = [String]()
        for (_ , info) in (self.allFolderList?.allFolderList?.enumerated())! {
            allCategoriesList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Folder", rows: allCategoriesList , initialSelection: 0 , doneBlock: { (picker, index, value) in
            let category = self.allFolderList?.allFolderList![index]
            
            self.btnChooseFolder.setTitle(category?.name , for: .normal)
            self.idOfSelectedFolder = category?.id
            print("values = \(value!)")
            print("indexes = \(index)")
            print("picker = \(picker!)")
            return
        }, cancel: { (actionStrin ) in
            
        }, origin: sender)
        
    }

    @IBAction func btnSelectSento(_ sender: UIButton) {
        
        var allCategoriesList = [String]()
        for (_ , info) in (self.userObject?.userList?.enumerated())! {
            allCategoriesList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select User", rows: allCategoriesList , initialSelection: 0 , doneBlock: { (picker, index, value) in
            let category = self.userObject?.userList![index]
            
            self.btnSentTo.setTitle(category?.name , for: .normal)
            self.idOfSelectUser = category?.id
            print("values = \(value!)")
            print("indexes = \(index)")
            print("picker = \(picker!)")
            return
        }, cancel: { (actionStrin ) in
            
        }, origin: sender)
        
    }
    @IBAction func btnBAck_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnUploadFile_Pressed(_ sender: UIButton) {
        let userId = localUserData.id
        
        //        let loginParam =  [ "userid"                        : "\(userId!)",
        //            ] as [String : Any]
        let params =        ["userid"                       :  "\(userId!)",
                             "folderid"                     :  "\(idOfSelectedFolder!)" ,
                             "sendto"                       :  "\(idOfSelectUser!)",
                             "note"                         :    txtOfNote.text!
                            ] as [String : Any]
        
        
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)

        WebServiceManager.multiPartImage(params: params as Dictionary<String, AnyObject>, serviceName: UPLOADFILE, imageParam: "file", serviceType: "upload Image", profileImage: cover_image, cover_image_param: "", cover_image: nil , modelType: UserResponse.self, success: { (response) in
            self.stopAnimating()

            let userResponse = (response as? UserResponse)
            if userResponse?.success == true {
                self.showAlert(title: "CPA", message: (userResponse?.message!)!, controller: self)
                self.txtOfNote.text = ""
                self.txtOfNote.placeholder = "Comment"

                
            } else {
                self.showAlert(title: "CPA", message: (userResponse?.message!)!, controller: self)

            }
        }) { (error) in
            self.showAlert(title: "", message: error.description , controller: self)
            self.stopAnimating()

        }
        
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
