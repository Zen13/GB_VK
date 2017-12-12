//
//  TodayViewController.swift
//  ExtensionNews
//
//  Created by Zen on 27.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    //let newsServices = VKNewsServices()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        
//        session.dataTask(with: url) { [weak self] data, response, error in
//            guard let data = data else {
//                assertionFailure()
//                return
//            }
//            let decoder = JSONDecoder()
//
//            do {
//                let result = try decoder.decode(Weather.self, from: data)
//                let temp = String(result.main.temp)
//                DispatchQueue.main.async {
//                    self?.labelView.text = temp
//                }
//            } catch {
//                print(error)
//            }
//
//
//
//
//            }.resume()
    }
    
    @IBOutlet weak var personalAvatar: UIImageView!
    @IBOutlet weak var personalName: UILabel!
    
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
