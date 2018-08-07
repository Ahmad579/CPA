//
//  CPAFileDetailVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 31/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPAFileDetailVC: UIViewController , NVActivityIndicatorViewable {
    @IBOutlet weak var textView: UITextView!
    var commentText :  String?
    let size = CGSize(width: 60, height: 60)
    var selectedFile : AllFileInFolder?
    var responseObj: UserResponse?
    var messageObj : Message?
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        WAShareHelper.setBorderAndCornerRadius(layer: textView.layer, width: 1.0, radius: 1.0, color: UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0))
        textView.placeholder = "Enter message here... "
        getDetailFile()
        // Do any additional setup after loading the view.
    }
    
//
    
    
    private func getDetailFile() {
        
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        let idOfSelectFile = selectedFile?.id
        let loginParam =  [ "id"                      : "\(idOfSelectFile!)"
            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: FILEDETAIL, isLoaderShow: true, serviceType: "File Detail", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
            } else {
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "CPA", message: error.description, controller: self)
        }, showHUD: true)
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBAck_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }

//

    @IBAction func btnPostMessage_Pressed(_ sender: UIButton) {
        
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        
        let folderId = selectedFile?.id
        let userId = localUserData.id
        
        //        let loginParam =  [ "userid"                        : "\(userId!)",
        //            ] as [String : Any]
        let loginParam =  [ "userid"                        : "\(userId!)",
                            "fileid"                      : "\(folderId!)" ,
                            "message"                       : textView.text!
            ] as [String : Any]
        
        textView.text = ""
        textView.placeholder = "Enter message here... "
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: CREATEMESSAGE, isLoaderShow: true, serviceType: "All folder", modelType: Message.self, success: { (response) in
            self.messageObj = (response as! Message)
            self.stopAnimating()
            
            if self.messageObj?.success == true {
                self.responseObj?.fileInFolderList![0].message?.append((self.messageObj?.data)!)
                self.tblView.beginUpdates()
                self.tblView.insertRows(at: [IndexPath(row: (self.responseObj?.fileInFolderList![0].message?.count)! - 1, section: 1)], with: .automatic)
                self.tblView.endUpdates()
            } else {
                self.showAlert(title: "CPA", message: (self.messageObj?.message!)!, controller: self)
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "CPA", message: error.description, controller: self)
        }, showHUD: true)
        
    }
}

extension CPAFileDetailVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
       return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        }  else {
            return (self.responseObj?.fileInFolderList![0].message?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "fileInfo", for: indexPath) as? CPAFileDetailCell
            cell?.lblSizeOfFile.text = self.responseObj?.fileInFolderList![0].size
            cell?.lblFileName.text = self.responseObj?.fileInFolderList![0].filename
            cell?.lblUploadedBy.text = self.responseObj?.fileInFolderList![0].uploadedby
            cell?.lblSentTo.text = self.responseObj?.fileInFolderList![0].sendto
            cell?.lblCreatedFile.text = self.responseObj?.fileInFolderList![0].date
//            let fileExt = self.responseObj?.fileInFolderList![0].file_ext
         
            let imageUrl = self.responseObj?.fileInFolderList![indexPath.row].icon
            WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: (cell?.imgOfFile)!, placeHolder: "add_new")

//            if fileExt == "jpg" {
//                cell?.imgOfFile.image = UIImage(named: "image")
//            }  else if fileExt == "mp3" {
//                cell?.imgOfFile.image = UIImage(named: "zip")
//
//            } else if fileExt == "pdf" {
//                cell?.imgOfFile.image = UIImage(named: "pdf")
//            } else if fileExt == "xml" {
//                cell?.imgOfFile.image = UIImage(named: "xml")
//
//            }
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Message", for: indexPath) as? CPAFileDetailCell
            cell?.lblMessageDate.text = self.responseObj?.fileInFolderList![0].message![indexPath.row].date
            cell?.lblMessageHere.text = self.responseObj?.fileInFolderList![0].message![indexPath.row].message
            WAShareHelper.setBorderAndCornerRadius(layer: (cell?.viewOfMessage.layer)!, width: 1.0, radius: 1.0, color: UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0))

            
            return cell!

        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 265.0
            
        } else {
            return UITableViewAutomaticDimension
            
        }
    }
}


extension UITextView :UITextViewDelegate
{
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}
