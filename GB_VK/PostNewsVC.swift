//
//  PostNewsVC.swift
//  GB_VK
//
//  Created by Zen on 16.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit

class PostNewsVC: UIViewController {
    
    let vkWallServices = VKNewsServices()
    var localForWallPost : (lat: Double, long: Double) = (0.0, 0.0)

    @IBOutlet weak var newsText: UITextView!
    @IBAction func actionAddLocation(_ sender: Any) {
    }
    @IBAction func actionPost(_ sender: Any) {
        vkWallServices.wallPost(owner_id: VKServices().loginUser_id, message: self.newsText.text, local: (lat: localForWallPost.lat, long: localForWallPost.long)){
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func myAction(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "backToWallPostFromLocal" {
           let localVC = unwindSegue.source as! AddLocationVC
            localForWallPost = (localVC.lat, localVC.long)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toAddLocalPosition" {
//            let ctrl = segue.destination as! AddLocationVC
//        }
//    }

}
