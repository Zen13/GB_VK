//
//  VKFriendsServices.swift
//  GB_VK
//
//  Created by Zen on 01.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import RealmSwift

class VKFriendsServices {
    
    private let syncQueue = DispatchQueue(label: "qwe", qos: .userInteractive)
    let servicesRequestSetting = VKServices()
    
    typealias loadFriendsDataCompletion = () -> Void
    typealias friendsCompletion = ([FriendsRequests]) -> Void
    
    func loadFriendList(completion: @escaping () -> () ) { //(completion: @escaping loadFriendsDataCompletion)
        
        let path = "method/friends.get?v=5.52"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "fields" : "nickname,domain,sex,photo_50,photo_100,photo_200_orig",
            "order" : "name"
        ]
        
        let url = servicesRequestSetting.baseURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] respons in
            guard let data = respons.value else { return }
            
            let json = JSON(data)
            let friends = json["response"]["items"].flatMap { User(json: $0.1) }
            
            self?.saveFriendsData(friends)
            completion()
        }        
    }
    
    func getFriendsRequests(completion: @escaping friendsCompletion) { //(completion: @escaping loadFriendsDataCompletion)
        
        let path = "method/friends.getRequests?v=5.69"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "extended" : 1,
            "need_mutual" : 1,
            "out" : 0,
            "need_viewed" : 1,
            "suggested" : 0
        ]
        
        let url = servicesRequestSetting.baseURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] respons in
            guard let data = respons.value else { return }
            
            let json = JSON(data)
            let friendsRequests = json["response"]["items"].flatMap {FriendsRequests(json: $0.1) }
            
            //self?.saveFriendsData(friends)
            completion(friendsRequests)
        }
    }
    
    
    func saveFriendsData(_ friends: [User]) {

        do {
            let realm = try Realm()
            let oldFriends = realm.objects(User.self)
            
            realm.beginWrite()
            realm.delete(oldFriends)
            //print(realm.configuration.fileURL)
            realm.add(friends)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
