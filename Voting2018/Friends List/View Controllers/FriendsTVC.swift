//
//  FriendsTVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 04.02.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import SwiftyVK
import SwiftyJSON

class FriendsTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Голоса друзей"
        updateData()
    }
    
    func updateData() {
        if VK.sessions.default.state != .authorized { ScreensManager.sI.showAuthFlow() }

        VK.API.Friends.get([
            .fields: "photo_50"
            ])
            .onSuccess { result in
                let json = try JSON(data: result)
                
                DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let user = appDelegate.user
                print("userid \(user?.userId)")
                }
                print("success result get info \(json)")
            
                
            } .onError {
                print("error result get info \($0)")
            }.send()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell

        // Configure the cell...

        return cell
    }
 

}
