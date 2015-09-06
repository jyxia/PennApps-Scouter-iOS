//
//  ScrollImageViewCell.swift
//  FilmScouter
//
//  Created by Jinyue Xia on 9/5/15.
//  Copyright (c) 2015 Jinyue Xia. All rights reserved.
//

import UIKit

class ScrollImageViewCell: UITableViewCell {

    @IBOutlet weak var imageScrollView: UIScrollView!
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        
}
