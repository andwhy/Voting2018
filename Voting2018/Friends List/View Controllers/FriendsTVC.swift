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
import NVActivityIndicatorView
import StoreKit

class FriendsTVC: UITableViewController {

    var friends: [Friend]?
    var candidates: [Candidate]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 10.3, *) {
            if !UserDefaults.standard.bool(forKey: "friendsScreenRate") {
                SKStoreReviewController.requestReview()
                UserDefaults.standard.set(true, forKey: "friendsScreenRate")
            }
        }
        
        self.title = "Голоса друзей"
        updateData()
    }
    
    func updateData() {
        if VK.sessions.default.state != .authorized { ScreensManager.sI.showAuthFlow() }

        NVActivityIndicatorPresenter.start()
        VK.API.Friends.get([
            .fields: "photo_200_orig"
            ])
            .onSuccess { result in
                let json = try JSON(data: result)
                
                var friends:[Friend] = []
                for (_, subJson):(String, JSON) in json["items"] {
                    let name = subJson["first_name"].stringValue + " " + subJson["last_name"].stringValue
                    friends.append(Friend(name: name, id: String.init(format: "%i", subJson["id"].int!), photo: subJson["photo_200_orig"].stringValue, selectCandidate: nil))
                }
                
                DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let user = appDelegate.user
                print("userid \(user?.userId)")
                    print("user \(user)")

                NetworkManager.sI.getVotedFriends(userId: (user?.userId)!, friends: friends) {
                        error, friends  in
                    NVActivityIndicatorPresenter.stop()
                        self.friends = friends
                        print("success result get info \(friends)")
                    self.tableView.reloadData()
                }
                    
                }
            
                
            } .onError {
                NVActivityIndicatorPresenter.stop()
                print("error result get info \($0)")
            }.send()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard friends != nil else { return 0 }
        return friends!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell

        let friend = friends![indexPath.row]
        
        cell.labelName.text = friend.name
        if friend.photo != nil  {
            cell.imageViewAvatar.kf.setImage(with: URL.init(string: friend.photo!))
        } else {
            cell.imageViewAvatar.image = nil
        }
        
        print(candidates)
        cell.labelResult.text = "Выбор: " + (candidates?.first(where: { $0.number == friend.selectCandidate! })?.shortName)!

        return cell
    }
 

}
