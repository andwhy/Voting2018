//
//  AuthStartVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 15.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import SwiftyVK
import SwiftyJSON

class AuthStartVC: UIViewController {

    @IBOutlet var buttonVKAuth: UIButton!
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    //MARK: Actions
    
    @IBAction func actionButtonVKAuth(_ sender: Any) {

        VK.sessions.default.logOut()
        VK.sessions.default.logIn(
            onSuccess: { _ in
                self.getUserInfoAndPushNexScreen()
            },
            onError: {
                self.getUserInfoAndPushNexScreen()
                print("error result auth \($0)")
            }
        )
    }
    
    
    //MARK: Helpers
    
    func getUserInfoAndPushNexScreen() {
        VK.API.Users.get([
            .fields: "sex,bdate,city,country"
            ])
            .onSuccess { result in
                let json = try JSON(data: result)
                print("success result get info \(json[0])")
                
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    
                    if let bdate = json[0]["bdate"].string {
                        let byearString = String(describing: bdate.split(separator: ".").last!)
                        let byear = Int(byearString)
                        let year = Calendar.current.component(.year, from: Date())
//                        print(year - byear!)
                        appDelegate.user?.age = year - byear!
                    }
                    
                    appDelegate.user?.city = json[0]["city"]["title"].stringValue
                    appDelegate.user?.country = json[0]["country"]["title"].stringValue
                    appDelegate.user?.sex = json[0]["sex"].intValue
                    appDelegate.user?.saveToKeychain()
                    
                    ScreensManager.sI.showCandidatesSelectionFlow()
                }
                
            } .onError {
                print("error result get info \($0)")
            }.send()
        
    }
    
}
