//
//  DetailStatisticsVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 22.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import Kingfisher

class DetailStatisticsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var imageViewAvatar: RoundedUIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelAge: UILabel!
    @IBOutlet var labelVotes: UILabel!
    @IBOutlet var segmentedControlStatType: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    var candidate: Candidate?
    var candidateDetailData: [[CandidateDetailData]]?
    
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
        
        NetworkManager.sI.getCandidateFullInfo(candidateNumber: (candidate?.number)!) { error, candidateFullInfo in
            self.candidateDetailData = candidateFullInfo
            self.tableView.reloadData()
        }
        
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
            labelVotes.text = text + " голосов"
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
        tableView.reloadData()
    }
    
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard candidateDetailData != nil else { return 0 }
        return candidateDetailData![segmentedControlStatType.selectedSegmentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailStatisticsCell", for: indexPath) as! DetailStatisticsCell

        let item = candidateDetailData![segmentedControlStatType.selectedSegmentIndex][indexPath.row]
        if segmentedControlStatType.selectedSegmentIndex != 3 {
            cell.labelTitle.text = item.name
        } else {
            cell.labelTitle.text = item.name == "1" ? "Женщины" : "Мужчины"
        }
        cell.labelQuantity.text = item.quantity
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
