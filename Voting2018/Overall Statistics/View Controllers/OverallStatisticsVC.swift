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

class OverallStatisticsVC: UIViewController, PieChartDelegate, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet var tableView: UITableView!
    @IBOutlet var viewPieChart: PieChart!
    var candidates:[Candidate] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        
        viewPieChart.innerRadius = viewPieChart.frame.width/8
        viewPieChart.outerRadius = viewPieChart.frame.width/2.5
        viewPieChart.delegate = self
//        viewPieChart.layers = [createTextWithLinesLayer(), createTextLayer()]
        viewPieChart.layers = [createTextLayer()]
        viewPieChart.isUserInteractionEnabled = false
    }

    func updateTitle() {
        var totalVotes = 0
        for candidate in candidates {
            totalVotes += candidate.allVotes
        }
        self.title = String.init(format: "Всего: %i голосов", totalVotes)
    }
    
    func updateData() {
        NetworkManager.sI.getCandidates() { error, candidates in
            if let resultCandidates = candidates {
                self.candidates = resultCandidates
                self.tableView.reloadData()
                
                let pieChartModels = resultCandidates.map({
                    PieSliceModel(value: Double($0.allVotes), color: UIColor.init(hexString: $0.color)!)
                })
                self.viewPieChart.models = pieChartModels
                
                self.updateTitle()
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


}
