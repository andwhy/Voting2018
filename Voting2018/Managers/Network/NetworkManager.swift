//
//  NetworkManager.swift
//  Voting2018
//
//  Created by Андрей Рожков on 16.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager {
    static let sI = NetworkManager()

    static let endPoint = "http://159.89.21.225/api/"
    
    var AlamofireManager: SessionManager {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 10
        manager.session.configuration.timeoutIntervalForResource = 10
        return manager
    }
    
    static let errorDescriptionNothing = "Request return NOTHING"
    
    
    
    //MARK: Candidates
    
    func getCandidates(completionHandler: @escaping (ErrorWithDescription, [Candidate]?) -> Void) {
        let parameters:[String : Any] = [:]
        let url:String = NetworkManager.endPoint + "getCandidates"
        
        AlamofireManager.request(url,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseData { (response:DataResponse) in
            
            guard let responseValue = response.result.value else {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
            do {
                let json = try JSON(data: responseValue)
                if json["status"].string! == "OK" {
                    print("getCandidates json \(json)")
                    
                    var candidates:[Candidate] = []
                    
                    for (_, subJson):(String, JSON) in json["candidates"] {
                        candidates.append(Candidate(json: subJson))
                    }

                    completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), candidates)
                    return
                }
            }
            catch {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
        }
    }
    
    
    //MARK: Vote
    
    func sendVoteAndUserData(selectedCandidate:Candidate, user: User, completionHandler: @escaping (ErrorWithDescription, [Candidate]?) -> Void) {
        let parameters:[String : Any] = [:]
        let url:String = NetworkManager.endPoint + "getCandidates"
        
        AlamofireManager.request(url,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseData { (response:DataResponse) in
            
            guard let responseValue = response.result.value else {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
            do {
                let json = try JSON(data: responseValue)
                if json["status"].string! == "OK" {
                    print("getCandidates json \(json)")
                    
                    var candidates:[Candidate] = []
                    
                    for (_, subJson):(String, JSON) in json["candidates"] {
                        candidates.append(Candidate(json: subJson))
                    }
                    
                    completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), candidates)
                    return
                }
            }
            catch {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
        }
    }


}
