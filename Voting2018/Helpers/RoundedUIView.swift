//
//  RoundedUIView.swift
//  Voting2018
//
//  Created by Андрей Рожков on 22.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit

class RoundedUIView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
