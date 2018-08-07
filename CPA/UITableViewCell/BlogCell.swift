//
//  BlogCell.swift
//  EventAppNew
//
//  Created by Ahmed Durrani on 12/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class BlogCell: UITableViewCell {

    @IBOutlet weak var imgOfBlog: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblCreatedDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnLike_Pressed(_ sender: UIButton) {
        
    }
    @IBAction func btnComment_Pressed(_ sender: UIButton) {
        
    }
    
}
