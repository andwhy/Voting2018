//
//  OverallStatisticsVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 20.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import PieCharts
import SwiftHEXColors
import NVActivityIndicatorView

class OverallStatisticsVC: UIViewController, PieChartDelegate, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet var tableView: UITableView!
    @IBOutlet var viewPieChart: PieChart!
    var candidates:[Candidate] = []
    var candidatesFilter:CandidatesFilter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let user = appDelegate.user
        print("self.user \(user)")

        
        updateData()
        
        viewPieChart.innerRadius = self.view.frame.width/8
        viewPieChart.outerRadius = self.view.frame.width/2.5
        viewPieChart.delegate = self
//        viewPieChart.layers = [createTextWithLinesLayer(), createTextLayer()]
        viewPieChart.layers = [createTextLayer()]
        viewPieChart.isUserInteractionEnabled = false
        
        self.tableView.tableHeaderView?.frame = CGRect(x: (self.tableView.tableHeaderView?.frame.origin.x)!, y: (self.tableView.tableHeaderView?.frame.origin.y)!, width: (self.tableView.tableHeaderView?.frame.width)!, height: self.view.frame.width)
        
    }

    func updateTitle() {
        var totalVotes = 0
        for candidate in candidates {
            totalVotes += candidate.allVotes
        }
        self.title = String.init(format: "Всего: %i голосов", totalVotes)
    }
    
    func updateData() {
        
        func finishUpdate() {
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            let pieChartModels = self.candidates.map({
                PieSliceModel(value: Double($0.allVotes), color: UIColor.init(hexString: $0.color)!)
            })
            self.viewPieChart.models = pieChartModels
            
            DispatchQueue.main.async {
                self.updateTitle()
            }
        }
        
        NVActivityIndicatorPresenter.start()
        
        NetworkManager.sI.getShareInfo() { error, shareWall in
            if shareWall?.isHide == 1 {
                NVActivityIndicatorPresenter.stop()
                ScreensManager.sI.showStopScreen(text: shareWall?.isHideText)
            }
        
        NetworkManager.sI.getCandidates() { error, candidates in
            if let resultCandidates = candidates {
                self.candidates = resultCandidates
                NVActivityIndicatorPresenter.stop()

                if let candidatesFilter = self.candidatesFilter, candidatesFilter.isActive()    {
                        NVActivityIndicatorPresenter.start()
                        NetworkManager.sI.getCandidatesByFilters(candidatesFilter:  self.candidatesFilter!, candidates: self.candidates) { error,        candidates in
                            NVActivityIndicatorPresenter.stop()
                            if let resultCandidates = candidates {
                                self.candidates = resultCandidates
                            }
                            finishUpdate()
                        }
                } else {
                    finishUpdate()
                }
            }
        }
        }
    }
    
    
    fileprivate func createTextLayer() -> PiePlainTextLayer {
        let textLayerSettings = PiePlainTextLayerSettings()
//        textLayerSettings.viewRadius = viewPieChart.frame.width/3.5
//        textLayerSettings.hideOnOverflow = true
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 15)
        textLayerSettings.label.textColor = UIColor.white
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLayerSettings.label.textGenerator = { slice in
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\($0)%"} ?? ""
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        return textLayer
    }

    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.lightGray
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 11)
        lineTextLayerSettings.label.labelGenerator = { slice in
            let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 100))
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 11)
            return label
        }
        lineTextLayerSettings.label.textGenerator = { slice in
            return self.candidates[slice.data.id].shortName ?? ""
        }
        
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
    
    func onSelected(slice: PieSlice, selected: Bool) {
        
    }
    
    
    //MARK: TableView delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return candidates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllVotesCell", for: indexPath) as! AllVotesCell
        let candidate = candidates[indexPath.row]
        
        cell.setName(text: candidate.shortName)
        cell.setVotes(number: candidate.allVotes)
        cell.setColor(colorHex: candidate.color)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"DetailStatisticsVC") as! DetailStatisticsVC
        vc.candidate = candidates[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "FriendsTVC") {
            let vc = segue.destination as! FriendsTVC
            vc.candidates = self.candidates
        }
    }
    
}
