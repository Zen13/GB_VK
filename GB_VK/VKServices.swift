//
//  VKServices.swift
//  GB_VK
//
//  Created by Zen on 26.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
//
//enum methodRequest : String {
//    case getMyFrends   = "/friends.get"
//    case getPhotos     = "/photos.getAll"
//    case getGroups     = "/groups.get"
//    case getGroupsById = "/groups.getById"
//    case searchGroup   = "/groups.search"
//}

let fetchCitiesWeatherGroup = DispatchGroup()
var timer: DispatchSourceTimer?

var lastUpdate: Date? {
    get {
        return UserDefaults.standard.object(forKey: "Last Update") as? Date
    }
    set {
        UserDefaults.standard.setValue(Date(), forKey: "Last Update")
    }
}

class VKServices {
    
//    enum ApiRequest: String {
//        case UsersGet = "method/users.get?v=5.8"
//    }
    
    let baseURL = "https://api.vk.com/"
    
    let apiKey = ""
    
    let API_ID = "6196172" //6197699
    
    var access_token : String {
        if KeychainWrapper.standard.string(forKey: "usersToken") == nil {
            return ""
        } else {
            return KeychainWrapper.standard.string(forKey: "usersToken")!
        }
    }
    
    
//    if access_tokenq != nil {
//        let access_token = access_tokenq
//    }
    var loginUser_id : String {
        let userDefaults = UserDefaults.standard
        if let user_id = userDefaults.string(forKey: "user_id") {
            return user_id
        } else {
            return ""
        }
    }
}
