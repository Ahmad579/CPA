//
//  CPAClientPortalDetailVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 21/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPAClientPortalDetailVC: UIViewController , NVActivityIndicatorViewable {
    
    var selectFolder : AllFolderObject?
    @IBOutlet weak var colllectionViewCell: UICollectionView!
    let size = CGSize(width: 60, height: 60)
    var responseObj: UserResponse?
    var allFolderList : UserResponse?
    var fileInFolder  : AllFolderObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colllectionViewCell.register(UINib(nibName: "ClientPortalCell", bundle: .main), forCellWithReuseIdentifier: "ClientPortalCell")
        // Do any additional setup after loading the view.
    }
    //
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllFileInFolder()

    }
    
    private func getAllFileInFolder() {
        
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        let userId = localUserData.id
        
        //        let loginParam =  [ "userid"                        : "\(userId!)",
        //            ] as [String : Any]

        let folderId = selectFolder?.id

        let loginParam =  [ "userid"                        : "\(userId!)",
                            "folderid"                      : "\(folderId!)"
            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: ALLFILEINFOLDER, isLoaderShow: true, serviceType: "All folder", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.colllectionViewCell.delegate = self
                self.colllectionViewCell.dataSource = self
                self.colllectionViewCell.reloadData()
            } else {
                self.colllectionViewCell.delegate = self
                self.colllectionViewCell.dataSource = self
                self.colllectionViewCell.reloadData()
                
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
    
    @IBAction func btnUploadFile_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPUploadFileVC") as? CPUploadFileVC
        vc?.allFolderList = self.allFolderList
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func btnBAck_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
}

extension CPAClientPortalDetailVC : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if  self.responseObj?.fileInFolderList?.isEmpty == false {
            numOfSections = 1
            collectionView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no File in this folder."
            noDataLabel.textColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
            noDataLabel.textAlignment = .center
            collectionView.backgroundView = noDataLabel
        }
        return numOfSections
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.responseObj?.fileInFolderList?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClientPortalCell", for: indexPath) as! ClientPortalCell
        
        cell.lblDocumentName.text = self.responseObj?.fileInFolderList![indexPath.row].filename
        let fileExt = self.responseObj?.fileInFolderList![indexPath.row].file_ext
        
        let imageUrl = self.responseObj?.fileInFolderList![indexPath.row].icon
        WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: (cell.imgOfFile)!, placeHolder: "add_new")

//        if fileExt == "jpg" || fileExt == "png" {
//            cell.imgOfFile.image = UIImage(named: "image")
//        }  else if fileExt == "mp3" {
//            cell.imgOfFile.image = UIImage(named: "zip")
//
//        } else if fileExt == "pdf" {
//            cell.imgOfFile.image = UIImage(named: "pdf")
//        } else if fileExt == "xml" {
//            cell.imgOfFile.image = UIImage(named: "xml")
//        }
        
        cell.lblSizeOfFile.text = self.responseObj?.fileInFolderList![indexPath.row].size
        cell.lblTitle.text = self.responseObj?.fileInFolderList![indexPath.row].note
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = self.colllectionViewCell.frame.size.width/2 - 20
        //        let heightOfCell = self.collectionViewCell.frame.size.height/6
        
        return CGSize(width: sizeOfCell, height: 150.0)
    }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPAFileDetailVC") as? CPAFileDetailVC
            vc?.selectedFile = self.responseObj?.fileInFolderList![indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    
}
