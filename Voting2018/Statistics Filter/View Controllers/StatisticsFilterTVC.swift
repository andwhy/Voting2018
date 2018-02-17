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
import StoreKit

class StatisticsFilterTVC: UITableViewController, RangeSeekSliderDelegate {

    @IBOutlet var checkBoxAge: M13Checkbox!
    @IBOutlet var sliderAge: RangeSeekSlider!
    @IBOutlet var contentViewAge: UIView!
    
    @IBOutlet var checkBoxGender: M13Checkbox!
    @IBOutlet var contentViewGender: UIView!
    @IBOutlet var segmentedViewGender: UISegmentedControl!
    @IBOutlet var buttonSearch: UIBarButtonItem!
    
    var candidatesFilter: CandidatesFilter = CandidatesFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.3, *) {
            if !UserDefaults.standard.bool(forKey: "filterScreenRate") {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(true, forKey: "filterScreenRate")
            }
        }
        
        sliderAge.numberFormatter.positiveSuffix = " лет"
        sliderAge.delegate = self
        
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
            candidatesFilter.minAge = Int(sliderAge.selectedMinValue)
            candidatesFilter.maxAge = Int(sliderAge.selectedMaxValue)
        } else {
            contentViewAge.isHidden = true
            candidatesFilter.minAge = nil
            candidatesFilter.maxAge = nil
        }
        
        if checkBoxGender.checkState == .checked {
            contentViewGender.isHidden = false
            candidatesFilter.sex = segmentedViewGender.selectedSegmentIndex == 0 ? 2 : 1
        } else {
            contentViewGender.isHidden = true
            candidatesFilter.sex = nil
        }
        
        if candidatesFilter.isActive() {
            buttonSearch.isEnabled = true
        } else {
            buttonSearch.isEnabled = false
        }
        
        tableView.reloadData()
    }
    
    @IBAction func actionCheckBoxAge(_ sender: Any) {
        updateView()
    }
    
    @IBAction func actionCheckBoxGender(_ sender: Any) {
        updateView()
    }
    
    @IBAction func actionButtonSearch(_ sender: Any) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"OverallStatisticsVC") as! OverallStatisticsVC
        
        vc.candidatesFilter = candidatesFilter
        vc.navigationItem.leftBarButtonItem = nil
        vc.navigationItem.rightBarButtonItem = nil
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSegmentGender(_ sender: Any) {
        candidatesFilter.sex = segmentedViewGender.selectedSegmentIndex == 0 ? 2 : 1
    }
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        candidatesFilter.minAge = Int(sliderAge.selectedMinValue)
        candidatesFilter.maxAge = Int(sliderAge.selectedMaxValue)
//        print(candidatesFilter.minAge)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableViewAutomaticDimension
    }
    
}
