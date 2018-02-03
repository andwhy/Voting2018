//
//  NetworkDataStructs.swift
//  Voting2018
//
//  Created by Андрей Рожков on 16.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import SwiftyJSON
import KeychainSwift

public struct ErrorWithDescription {
    
    var error:Bool
    var description:String?
    var number: Int?
    
    init(error:Bool,
         description:String? = nil,
         number: Int? = nil) {
        self.error = error
        self.description = description
        self.number = number
    }
    
    func isFalse() -> Bool{
        if self.error == true {
            return false
        } else {
            return true
        }
    }
}

public struct Candidate {
    
    var id:String
    var shortName:String?
    var fullName:String?
    var photoPath:String
    var age:Int
    var v:Int
    var number:Int
    var allVotes:Int
    var color:String
    
    init(json: JSON) {
        self.id = json["_id"].string!
        self.shortName = json["shortName"].string!
        self.fullName = json["fullName"].string!
        self.photoPath = json["photo_path"].string!
        self.age = json["age"].int!
        self.v = json["__v"].int!
        self.number = json["number"].int!
        self.allVotes = json["all_votes"].int!
        self.color = String((json["color"].string!).dropFirst().dropFirst().dropFirst())
    }
}

public struct ShareWall {
    
    var postText:String?
    var postImg:String?
    var postUrl:String?

    init(json: JSON) {
        self.postText = json["post_text"].string!
        self.postImg = json["post_img"].string!
        self.postUrl = json["post_url"].string!
    }
}

public struct CandidatesFilter {
    
    var country:String?
    var city: String?
    var minAge:Int?
    var maxAge:Int?
    var sex:Int?
    
    init(country: String? = nil,
        city: String? = nil,
        minAge: Int? = nil,
        maxAge: Int? = nil,
        sex: Int? = nil ) {
        
        self.country = country
        self.city = city
        self.minAge = minAge
        self.maxAge = maxAge
        self.sex = sex
    }
    
    func isActive() -> Bool {
        if self.city != nil || self.country != nil || self.minAge != nil || self.maxAge != nil || self.sex != nil {
            return true
        } else {
            return false
        }
    }
}

public struct User {
    
    var regType:String?
    var userToken:String?
    var userId:String?
    var isHide:Int?
    var age:Int?
    var city:String?
    var country:String?
    var sex:Int?
    var selectCandidate:Int?
    
    func saveToKeychain() {
        let keychain = KeychainSwift()
        
        if let regType = self.regType {
            keychain.set(regType, forKey: "reg_type")
        }
        if let userToken = self.userToken {
            keychain.set(userToken, forKey: "user_token")
        }
        if let userId = self.userId {
            keychain.set(userId, forKey: "user_id")
        }
        if let isHide = self.isHide {
            let isHideString = String.init(format: "%i", isHide)
            keychain.set(isHideString, forKey: "is_hide")
        }
        if let age = self.age {
            let ageString = String.init(format: "%i", age)
            keychain.set(ageString, forKey: "age")
        }
        if let city = self.city {
            keychain.set(city, forKey: "city")
        }
        if let country = self.country {
            keychain.set(country, forKey: "country")
        }
        if let sex = self.sex {
            let sexString = String.init(format: "%i", sex)
            keychain.set(sexString, forKey: "sex")
        }
        if let selectCandidate = self.selectCandidate {
            let selectCandidateString = String.init(format: "%i", selectCandidate)
            keychain.set(selectCandidateString, forKey: "select_candidate")
        }
    }
}

