//
//  TodayViewController.swift
//  ExtensionWall
//
//  Created by Zen on 29.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//  test

import UIKit
import NotificationCenter
import Alamofire

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var nameNewFriend: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    
    private var downloadQueue = OperationQueue()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFriendsRequests()
        // Do any additional setup after loading the view from its nib.
    }
    
    private func loadFriendsRequests() {
        let friendsRequestsOperation = LoadFriendsRequestsIDOperation()

        let loadNewFriendsOperation = LoadNewFriendsOperation()
        loadNewFriendsOperation.completionBlock = {
            DispatchQueue.main.async {
                self.nameNewFriend.text = loadNewFriendsOperation.userName
                self.labelCity.text = loadNewFriendsOperation.userLocation
            }
        }
        loadNewFriendsOperation.addDependency(friendsRequestsOperation)
        downloadQueue.addOperation(friendsRequestsOperation)
        downloadQueue.addOperation(loadNewFriendsOperation)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
