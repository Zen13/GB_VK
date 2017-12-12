//
//  VKUserServices.swift
//  GB_VK
//
//  Created by Zen on 01.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class VKUserServices {
    
    let servicesRequestSetting = VKServices()
    
    typealias loadUserDataCompletion = ([User]) -> Void

    func loadUserInfo(user_id: String, completion: @escaping loadUserDataCompletion) {
        
        let path = "method/users.get?v=5.8"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "user_ids" : user_id == "" ? servicesRequestSetting.loginUser_id : user_id,
            "fields" : "first_name,last_name,sex,photo_50,photo_100,counters"
        ]
        
        let url = servicesRequestSetting.baseURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { respons in
            guard let data = respons.value else { return }
            
            let json = JSON(data)
            let user = json["response"].flatMap { User(json: $0.1) }

            completion(user)
        }        
    }
}
