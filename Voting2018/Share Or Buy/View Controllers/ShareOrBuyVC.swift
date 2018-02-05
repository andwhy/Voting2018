//
//  ShareOrBuyVC.swift
//  Voting2018
//
//  Created by Андрей Рожков on 31.01.2018.
//  Copyright © 2018 Andrey Rozhkov. All rights reserved.
//

import UIKit
import SwiftyVK
import SwiftyJSON
import NVActivityIndicatorView

class ShareOrBuyVC: UIViewController {

    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var buttonShare: UIButton!
    @IBOutlet var buttonBuyPro: UIButton!
    

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBuyPro.isEnabled = false
        
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = { type in
            if type == .purchased || type  == .restored {
                NVActivityIndicatorPresenter.stop()
                print("Куплено или восстановлено")
                
                DispatchQueue.main.async {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.user?.paidApp = true
                appDelegate.user?.saveToKeychain()
                }
                
                ScreensManager.sI.showStatisticsFlow()
            } else if type == .fetched {
                self.buttonBuyPro.isEnabled = true
                let iapProducts = IAPHandler.shared.iapProducts
                for product in iapProducts{
                    let numberFormatter = NumberFormatter()
                    numberFormatter.formatterBehavior = .behavior10_4
                    numberFormatter.numberStyle = .currency
                    numberFormatter.locale = product.priceLocale
                    let price1Str = numberFormatter.string(from: product.price)
                    print(product.localizedDescription + "\nfor just \(price1Str!)")
                    
                    self.buttonBuyPro.setTitle("КУПИТЬ PRO - " + price1Str!, for: .normal)
                }
            } else {
                NVActivityIndicatorPresenter.stop()
            }
        }
    }

    @IBAction func actionButtonShare(_ sender: Any) {
        
        NVActivityIndicatorPresenter.start()
        NetworkManager.sI.getShareInfo() { error, shareWall in
            NVActivityIndicatorPresenter.stop()
            guard let shareWall = shareWall else { return }
            
            print(shareWall.postUrl! + "," + shareWall.postImg!)
            
            VK.API.Wall.post([
                .message: shareWall.postText,
                .attachments : shareWall.postUrl! + "," + shareWall.postImg!
                ]).onSuccess { result in
                    let json = try JSON(data: result)
                    print("success result get info \(json)")
                    //                NVActivityIndicatorPresenter.stop()
                    
                    DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.user?.sharedApp = true
                    appDelegate.user?.saveToKeychain()
                    }
                    
                    ScreensManager.sI.showStatisticsFlow()
                } .onError {
                    print("error result get info \($0)")
                    //                NVActivityIndicatorPresenter.stop()
                }.send()
        }
        

    }
    
    @IBAction func actionButtonBuyPro(_ sender: Any) {
        IAPHandler.shared.purchaseMyProduct(index: 0)
        NVActivityIndicatorPresenter.start()
    }
    
    @IBAction func actionButtonRestorePurchase(_ sender: Any) {
        IAPHandler.shared.restorePurchase()
        NVActivityIndicatorPresenter.start()
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Попробуте еще раз", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ок", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
