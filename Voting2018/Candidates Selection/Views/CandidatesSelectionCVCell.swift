//
//  CandidatesSelectionCVCell.swift
//  Voting2018
//
//  Created by Андрей Рожков on 16.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import Kingfisher
import M13Checkbox

class CandidatesSelectionCVCell: UICollectionViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var cellWidth: NSLayoutConstraint!
    @IBOutlet var checkBoxSelect: M13Checkbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkBoxSelect.boxType = .square
        checkBoxSelect.stateChangeAnimation = .fill
        checkBoxSelect.markType = .checkmark
        checkBoxSelect.isUserInteractionEnabled = false
    }
    
    func setName(text: String?) {
        if let text = text {
            nameLabel.text = text
        } else {
            nameLabel.text = ""
        }
    }
    
    func setAge(number: Int?) {
        if let number = number {
            ageLabel.text = String.init(format: "%i лет", number)
        } else {
            ageLabel.text = ""
        }
    }
    
    func setAvatar(urlString: String?) {
        guard let urlString = urlString else {
            avatarImageView.kf.cancelDownloadTask()
            avatarImageView.image = nil
            return
        }
        if let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url)
        } else {
            avatarImageView.kf.cancelDownloadTask()
            avatarImageView.image = nil
        }
    }
    
    func stopDownloadingAvatar() {
        avatarImageView.kf.cancelDownloadTask()
        avatarImageView.image = nil
    }
    
    func setWidth(screenWidth: CGFloat) {
        cellWidth.constant = (screenWidth / 2) - 10 - 5
    }
    
    func setSelected(bool: Bool) {
        if bool == true {
            checkBoxSelect.setCheckState(.checked, animated: bool)
        } else {
            checkBoxSelect.setCheckState(.unchecked, animated: bool)
        }
    }
    
}
