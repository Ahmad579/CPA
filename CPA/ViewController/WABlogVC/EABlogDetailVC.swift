//
//  EABlogDetailVC.swift
//  EventAppNew
//
//  Created by Ahmed Durrani on 12/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class EABlogDetailVC: UIViewController {

    @IBOutlet weak var imgOfBlog: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    var  blogDetail : BlogObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl = blogDetail?.image
        WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: (imgOfBlog)!, placeHolder: "placeholder")
        lblTitle.text = blogDetail?.title
//        lblCategory.text = blogDetail?.category
//        lblDate.text = blogDetail?.created_at
//        lblDescription.text = blogDetail?.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnComment_Pressed(_ sender: UIButton) {
        
//    let vc = self.storyboard?.instantiateViewController(withIdentifier:"WACommentVC") as? WACommentVC
//    vc?.commentBlog = blogDetail
//    self.navigationController?.pushViewController(vc!, animated: true)
        
    }
   

}
