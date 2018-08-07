//
//  CPAFileDetailCell.swift
//  CPA
//
//  Created by Ahmed Durrani on 31/07/2018.
//  Copyright © 2018 Tech Ease Solution. All rights reserved.
//

import UIKit

class CPAFileDetailCell: UITableViewCell {

    @IBOutlet weak var lblSizeOfFile: UILabel!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var lblUploadedBy: UILabel!
    @IBOutlet weak var lblSentTo: UILabel!
    
    @IBOutlet weak var lblCreatedFile: UILabel!
    
    @IBOutlet weak var lblMessageHere: UILabel!
    @IBOutlet weak var lblMessageDate: UILabel!
    
    @IBOutlet weak var imgOfFile: UIImageView!
    @IBOutlet weak var viewOfMessage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
