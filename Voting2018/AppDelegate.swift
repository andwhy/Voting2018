//
//  AppDelegate.swift
//  Voting2018
//
//  Created by Андрей Рожков on 15.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import SwiftyVK
import KeychainSwift
import NVActivityIndicatorView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var user: User?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setUpUser()
        setUpSDKs()
        setupNVActivityIndicator()
        
        if VK.sessions.default.state == .authorized || user?.userToken != nil {
            
            if VK.sessions.default.state != .authorized {
                do {
                    try VK.sessions.default.logIn(rawToken: (user?.userToken!)!, expires: 0)
                    print("login success")
                } catch {
                    print("login error")
                    ScreensManager.sI.showAuthFlow()
                    return false
                }
            }
            if user!.isAlreadyVoted() {
                if user!.isSharedOrPaid() {
                    ScreensManager.sI.showStatisticsFlow()
                } else {
                    ScreensManager.sI.showShareOrBuyFlow()
                }
            } else {
                ScreensManager.sI.showCandidatesSelectionFlow()
            }

        } else {
            ScreensManager.sI.showAuthFlow()
        }

    
        
        print("user from app delegate \(user)")
        
        return true
    }

    func setupNVActivityIndicator() {
        NVActivityIndicatorView.DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        NVActivityIndicatorView.DEFAULT_TYPE = .lineSpinFadeLoader
    }
    
    func setUpSDKs() {
       _ = VKDelegate.sI
        VK.sessions.default.config.language = .ru
    }
    
    func setUpUser() {
        
        if user == nil {
            let keychain = KeychainSwift()
            let regType = keychain.get("reg_type")
            let userToken = keychain.get("user_token")
            let userId = keychain.get("user_id")
            var isHide:Int? = nil
            if let isHideString = keychain.get("is_hide") {
                isHide = Int(isHideString)
            }
            var age:Int? = nil
            if let ageString = keychain.get("age") {
                age = Int(ageString)
            }
            let city = keychain.get("city")
            let country = keychain.get("country")
            var sex:Int? = nil
            if let sexString = keychain.get("sex") {
                sex = Int(sexString)
            }
            var selectCandidate:Int? = nil
            if let selectCandidateString = keychain.get("select_candidate") {
                selectCandidate = Int(selectCandidateString)
            }
            var sharedApp:Bool? = nil
            if let sharedAppString = keychain.get("shared_app") {
                sharedApp = Bool(truncating: (NSNumber(value:Int(sharedAppString)!)))
            }
            var paidApp:Bool? = nil
            if let paidAppString = keychain.get("paid_app") {
                paidApp = Bool(truncating: (NSNumber(value:Int(paidAppString)!)))
            }
            
            self.user = User(regType: regType, userToken: userToken, userId: userId, isHide: isHide, age: age, city: city, country: country, sex: sex, selectCandidate: selectCandidate, sharedApp:sharedApp, paidApp:paidApp)
            print("self.user \(self.user)")
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

