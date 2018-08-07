//
//  CPClientPortalVC.swift
//  CPA
//
//  Created by Ahmed Durrani on 19/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CPClientPortalVC: UIViewController , NVActivityIndicatorViewable {
    
    
    @IBOutlet weak var colllectionViewCell: UICollectionView!
    let size = CGSize(width: 60, height: 60)
    var responseObj: UserResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        colllectionViewCell.register(UINib(nibName: "ClientPortalCell", bundle: .main), forCellWithReuseIdentifier: "ClientPortalCell")
        NotificationCenter.default.addObserver(self, selector: #selector(CPClientPortalVC.notifyFile(_:)), name: NSNotification.Name(rawValue: "verifyDocument"), object: nil)
        getAllFolder()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func notifyFile(_ notification: NSNotification) {
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        let userId = localUserData.id
        
        let loginParam =  [ "userid"                        : "\(userId!)",
            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: GETALLFOLDER, isLoaderShow: true, serviceType: "All folder", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.colllectionViewCell.delegate = self
                self.colllectionViewCell.dataSource = self
                self.colllectionViewCell.reloadData()
            } else {
                
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "CPA", message: error.description, controller: self)
        }, showHUD: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    
    private func getAllFolder() {
        
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        let userId = localUserData.id

        let loginParam =  [ "userid"                        : "\(userId!)",
            ] as [String : Any]
        
        WebServiceManager.post(params:loginParam as Dictionary<String, AnyObject> , serviceName: GETALLFOLDER, isLoaderShow: true, serviceType: "All folder", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.stopAnimating()
            
            if self.responseObj?.success == true {
                self.colllectionViewCell.delegate = self
                self.colllectionViewCell.dataSource = self
                self.colllectionViewCell.reloadData()
            } else {
                
                
            }
            
        }, fail: { (error) in
            self.stopAnimating()
            self.showAlert(title: "CPA", message: error.description, controller: self)
        }, showHUD: true)
        
    }
    @IBAction func btnCreate_File_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateFileVC") as? CreateFileVC
        if #available(iOS 10.0, *) {
            vc?.modalPresentationStyle = .overCurrentContext
        } else {
            vc?.modalPresentationStyle = .currentContext
        }
        vc?.providesPresentationContextTransitionStyle = true
        present(vc!, animated: true, completion: {() -> Void in
        })
    }
    
    
    @IBAction func btnLeft_MenuPressed(_ sender: UIButton) {
        self.revealController.show(self.revealController.leftViewController)
    }
}
extension CPClientPortalVC : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.responseObj?.allFolderList?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClientPortalCell", for: indexPath) as! ClientPortalCell
        cell.lblDocumentName.text = self.responseObj?.allFolderList![indexPath.row].name
        let totalFile = self.responseObj?.allFolderList![indexPath.row].totalFile
        cell.lblTitle.text = "\(totalFile!) items"
        cell.lblSizeOfFile.isHidden = true
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = self.colllectionViewCell.frame.size.width/2 - 20
        //        let heightOfCell = self.collectionViewCell.frame.size.height/6
        
        return CGSize(width: sizeOfCell, height: 150.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CPAClientPortalDetailVC") as? CPAClientPortalDetailVC
        vc?.allFolderList = self.responseObj
//        vc?.fileInFolder = self.responseObj?.allFolderList![indexPath.row]
        vc?.selectFolder = self.responseObj?.allFolderList![indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
