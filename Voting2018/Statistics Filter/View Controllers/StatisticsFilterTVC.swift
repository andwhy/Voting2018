//
//  StatisticsFilterTVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 01.02.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import M13Checkbox
import RangeSeekSlider

class StatisticsFilterTVC: UITableViewController {

    @IBOutlet var checkBoxAge: M13Checkbox!
    @IBOutlet var sliderAge: RangeSeekSlider!
    @IBOutlet var contentViewAge: UIView!
    
    @IBOutlet var checkBoxGender: M13Checkbox!
    @IBOutlet var contentViewGender: UIView!
    @IBOutlet var segmentedViewGender: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderAge.numberFormatter.positiveSuffix = " лет"
        
        for checkBox in [checkBoxAge, checkBoxGender] as! [M13Checkbox] {
            checkBox.boxType = .square
            checkBox.stateChangeAnimation = .fill
            checkBox.markType = .checkmark
        }
        
        updateView()
    }

    func updateView() {
        if checkBoxAge.checkState == .checked {
            contentViewAge.isHidden = false
        } else {
            contentViewAge.isHidden = true
        }
        
        if checkBoxGender.checkState == .checked {
            contentViewGender.isHidden = false
        } else {
            contentViewGender.isHidden = true
        }
        tableView.reloadData()
    }
    
    @IBAction func actionCheckBoxAge(_ sender: Any) {
        updateView()
    }
    
    @IBAction func actionCheckBoxGender(_ sender: Any) {
        updateView()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableViewAutomaticDimension
    }
    
}
