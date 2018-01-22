//
//  DetailStatisticsVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 22.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import Kingfisher

class DetailStatisticsVC: UIViewController {

    @IBOutlet var imageViewAvatar: RoundedUIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelAge: UILabel!
    @IBOutlet var labelVotes: UILabel!
    @IBOutlet var segmentedControlStatType: UISegmentedControl!
    
    var candidate: Candidate?
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateData()
    }
    
    func updateData() {
        setName(text: candidate?.fullName)
        setAvatar(urlString: candidate?.photoPath)
        setVotes(text: String.init(format: "%i", (candidate?.allVotes)!))
        setAge(number: candidate?.age)
    }
    
    func setName(text: String?) {
        if let text = text {
            labelName.text = text
        } else {
            labelName.text = ""
        }
    }
    
    func setVotes(text: String?) {
        if let text = text {
            labelVotes.text = text
        } else {
            labelVotes.text = ""
        }
    }
    
    func setAge(number: Int?) {
        if let number = number {
            labelAge.text = String.init(format: "%i лет", number)
        } else {
            labelAge.text = ""
        }
    }
    
    func setAvatar(urlString: String?) {
        guard let urlString = urlString else {
            imageViewAvatar.kf.cancelDownloadTask()
            imageViewAvatar.image = nil
            return
        }
        if let url = URL(string: urlString) {
            imageViewAvatar.kf.setImage(with: url)
        } else {
            imageViewAvatar.kf.cancelDownloadTask()
            imageViewAvatar.image = nil
        }
    }


    
    //MARK: Actions
    @IBAction func actionSegmentedControlStatType(_ sender: Any) {
    }
}
