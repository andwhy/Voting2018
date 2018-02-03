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

                    completionHandler(ErrorWithDescription(error: false, description: NetworkManager.errorDescriptionNothing), candidates)
                    return
                }
            }
            catch {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
        }
    }
    
    func getCandidatesByFilters(candidatesFilter: CandidatesFilter, candidates: [Candidate], completionHandler: @escaping (ErrorWithDescription, [Candidate]?) -> Void) {
        var parameters:[String : Any] = [:]
        let url:String = NetworkManager.endPoint + "getCandidatesByFilters"
        
        if candidatesFilter.sex != nil { parameters["sex"] = candidatesFilter.sex }
        if candidatesFilter.country != nil { parameters["country"] = candidatesFilter.country }
        if candidatesFilter.city != nil { parameters["city"] = candidatesFilter.city }
        if candidatesFilter.maxAge != nil { parameters["maxAge"] = candidatesFilter.maxAge }
        if candidatesFilter.minAge != nil { parameters["minAge"] = candidatesFilter.minAge }
        
        print(parameters)
        
        AlamofireManager.request(url,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseData { (response:DataResponse) in
            
            guard let responseValue = response.result.value else {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
            do {
                let json = try JSON(data: responseValue)
                if json["status"].string! == "OK" {
                    print("getCandidates json \(json)")
                    
                    var candidatesFinal: [Candidate] = []
                    
                    for (_, subJson):(String, JSON) in json["result"] {
                        let number = subJson["_id"]["value"].int!
                        var candidate = candidates.first(where: { $0.number == number })
                        candidate?.allVotes = subJson["total_votes"].int!
                        candidatesFinal.append(candidate!)
                        print("candidate \(candidate)")
                    }
                    
                    completionHandler(ErrorWithDescription(error: false, description: NetworkManager.errorDescriptionNothing), candidatesFinal)
                    return
                }
            }
            catch {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
        }
    }
    
    
    func getShareInfo(completionHandler: @escaping (ErrorWithDescription, ShareWall?) -> Void) {
        let parameters:[String : Any] = [:]
        let url:String = NetworkManager.endPoint + "getVotesConfig"
        
        AlamofireManager.request(url,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseData { (response:DataResponse) in
            
            guard let responseValue = response.result.value else {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
            do {
                let json = try JSON(data: responseValue)
//                if json["status"].string! == "OK" {
                    print("getshareWall json \(json)")
                    
                    let shareWall = ShareWall(json: json)
                    
                    completionHandler(ErrorWithDescription(error: false, description: NetworkManager.errorDescriptionNothing), shareWall)
                    return
//                }
            }
            catch {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing), nil)
                return
            }
        }
    }
    
    
    
    //MARK: Vote
    
    func sendVoteAndUserData(user: User, completionHandler: @escaping (ErrorWithDescription) -> Void) {
        var parameters:[String : Any] = [:]
        let url:String = NetworkManager.endPoint + "regVoter"
        
        parameters["regType"] = user.regType
        parameters["user_token"] = user.userToken
        parameters["user_id"] = user.userId
        parameters["is_hide"] = user.isHide
        parameters["age"] = user.age
        parameters["city"] = user.city
        parameters["country"] = user.country
        parameters["sex"] = user.sex
        parameters["select_candidate"] = user.selectCandidate

        AlamofireManager.request(url,  method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseData { (response:DataResponse) in
            
            guard let responseValue = response.result.value else {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing))
                return
            }
            do {
                let json = try JSON(data: responseValue)
                
                if json["status"].string! == "OK" {
                    print("regVoter json \(json)")
                    
                    var candidates:[Candidate] = []
                    
                    for (_, subJson):(String, JSON) in json["candidates"] {
                        candidates.append(Candidate(json: subJson))
                    }
                    
                    completionHandler(ErrorWithDescription(error: false, description: NetworkManager.errorDescriptionNothing))
                    return
                } else {
                    print("regVoter json status != ok \(json)")

                }
            }
            catch {
                completionHandler(ErrorWithDescription(error: true, description: NetworkManager.errorDescriptionNothing))
                return
            }
        }
    }

    
    

}
