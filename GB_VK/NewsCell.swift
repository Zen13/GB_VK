//
//  NewsCell.swift
//  GB_VK
//
//  Created by Zen on 16.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var newsMainImg: UIImageView!
    @IBOutlet weak var newsText: UITextView!
    @IBOutlet weak var newsAutorName: UILabel!    
    @IBOutlet weak var newsAutorAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
