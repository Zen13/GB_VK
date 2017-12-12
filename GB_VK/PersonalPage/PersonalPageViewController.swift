//
//  PersonalPageViewController.swift
//  GB_VK
//
//  Created by Zen on 01.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit

class PersonalPageViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var numberOfFriends: UILabel!
    @IBOutlet weak var numberOfGroups: UILabel!
    @IBAction func exitButton(_ sender: Any) {
        //self.reloadInputViews()
    }
    
    let userServices = VKUserServices()
    let imageServices = VKImageServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userServices.loadUserInfo(user_id: "") { [weak self] userArray in
            if userArray.count > 0 {
                let user = userArray[0]
                self?.name.text = user.fullName
                self?.numberOfFriends.text = self?.getStringProperty(property: user.counters["friends"])
                self?.numberOfGroups.text = self?.getStringProperty(property: user.counters["groups"])
                self?.imageServices.loadImage(url: user.photo_100) { [weak self] img in
                    self?.avatar.image = img
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PersonalPageViewController {
    
    func getStringProperty(property: Int?) -> String {
        if let intProperty = property {
            return String(intProperty)
        } else {
            return ""
        }
    }
}
