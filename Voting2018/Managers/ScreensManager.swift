//
//  ScreensManager.swift
//  Voting2018
//
//  Created by Андрей Рожков on 15.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit

class ScreensManager {
    
    static let sI = ScreensManager()
    
    func showAuthFlow() {
        
        DispatchQueue.main.async {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Authorization", bundle: nil)
        let nController = storyboard.instantiateViewController(withIdentifier :"StartNC") as! UINavigationController

        appDelegate.window?.rootViewController = nController
        appDelegate.window?.makeKeyAndVisible()
        }
    }

    func showCandidatesSelectionFlow() {
        
        DispatchQueue.main.async {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nController = storyboard.instantiateViewController(withIdentifier :"StartNC") as! UINavigationController
        
        appDelegate.window?.rootViewController = nController
        appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func showStatisticsFlow(candidatesFilter: CandidatesFilter?) {
        DispatchQueue.main.async {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nController = storyboard.instantiateViewController(withIdentifier :"OverallStatisticsNC") as! UINavigationController
        
        let vc = nController.viewControllers.first as! OverallStatisticsVC
    
        if candidatesFilter != nil { vc.candidatesFilter = candidatesFilter! }
            
        appDelegate.window?.rootViewController = nController
        appDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func showShareOrBuyFlow() {
        
        DispatchQueue.main.async {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nController = storyboard.instantiateViewController(withIdentifier :"ShareOrBuyNC") as! UINavigationController
        
        appDelegate.window?.rootViewController = nController
        appDelegate.window?.makeKeyAndVisible()
        }
    }


}
