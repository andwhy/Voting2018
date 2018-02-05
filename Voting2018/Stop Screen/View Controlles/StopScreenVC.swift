//
//  StopScreenVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 04.02.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit

class StopScreenVC: UIViewController {

    @IBOutlet var labelText: UILabel!
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let text = text {
            labelText.text = text
        }
    }

}
