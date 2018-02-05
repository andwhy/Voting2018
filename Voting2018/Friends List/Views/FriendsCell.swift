//
//  FriendsCell.swift
//  Voting2018
//
//  Created by Андрей Рожков on 04.02.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet var imageViewAvatar: RoundedUIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
