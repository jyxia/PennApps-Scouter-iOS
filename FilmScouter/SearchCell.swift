//
//  SearchCell.swift
//  FilmScouter
//
//  Created by Jinyue Xia on 9/5/15.
//  Copyright (c) 2015 Jinyue Xia. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
