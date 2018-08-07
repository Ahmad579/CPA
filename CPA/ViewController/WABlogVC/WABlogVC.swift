//
//  WABlogVC.swift
//  EventAppNew
//
//  Created by Ahmed Durrani on 12/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class WABlogVC: UIViewController , NVActivityIndicatorViewable {
    @IBOutlet var tblView: UITableView!
    var responseObj: UserResponse?
    let size = CGSize(width: 60, height: 60)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
        tblView.tableFooterView = UIView()
       
        getAllBlog()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func btnLeft_MenuPressed(_ sender: UIButton) {
        self.revealController.show(self.revealController.leftViewController)
        
    }
    
    
    private func getAllBlog() {
        
        startAnimating(size, message: "", messageFont: nil , type: NVActivityIndicatorType(rawValue: 6), color:UIColor.white   , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil , textColor: UIColor.white)
        WebServiceManager.get(params: nil, serviceName: BLOGLIST, serviceType: "Blog ", modelType: UserResponse.self, success: { (response) in
            self.responseObj = (response as! UserResponse)
            self.stopAnimating()
            if  self.responseObj?.success == true {
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
                
            }
            else {
                
            }
        }) { (error) in
            
            self.stopAnimating()
            
            
        }
    }
    
}


extension WABlogVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if  self.responseObj?.blog?.isEmpty == false {
            numOfSections = 1
            tblView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblView.bounds.size.width, height: tblView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no data."
            noDataLabel.textColor = UIColor(red: 119.0 / 255.0, green: 119.0 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)
            noDataLabel.textAlignment = .center
            tblView.backgroundView = noDataLabel
            tblView.separatorStyle = .none
        }
        return numOfSections
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.responseObj?.blog?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell", for: indexPath) as? BlogCell
        let imageUrl = self.responseObj?.blog![indexPath.row].image
        WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: (cell?.imgOfBlog)!, placeHolder: "placeholder")
        
        cell?.lblTitle.text = self.responseObj?.blog![indexPath.row].title
        cell?.lblCategory.text = self.responseObj?.blog![indexPath.row].title
        cell?.lblCreatedDate.text = self.responseObj?.blog![indexPath.row].date



        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EABlogDetailVC") as? EABlogDetailVC
//        vc?.blogDetail = self.responseObj?.blog![indexPath.row]
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  307.0
    }
}
