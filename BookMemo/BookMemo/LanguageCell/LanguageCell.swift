//
//  LanguageCell.swift
//  BookMemo
//
//  Created by BessieJiang on 5/20/20.
//
//

import UIKit

class LanguageCell: UITableViewCell {

    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var codeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

