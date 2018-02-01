//
//  AllVotesCell.swift
//  Voting2018
//
//  Created by Андрей Рожков on 22.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import SwiftHEXColors

class AllVotesCell: UITableViewCell {

    @IBOutlet var viewColor: UIView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelVotes: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

    func setName(text: String?) {
        if let text = text {
            labelName.text = text
        } else {
            labelName.text = ""
        }
    }
    
    func setVotes(number: Int?) {
        if let number = number {
            labelVotes.text = String.init(format: "%i голосов", number)
        } else {
            labelVotes.text = ""
        }
    }
    
    func setColor(colorHex: String?) {
        if let colorHex = colorHex {
            viewColor.backgroundColor = UIColor.init(hexString: colorHex)
        } else {
            viewColor.backgroundColor = UIColor.clear
        }
    }

}
