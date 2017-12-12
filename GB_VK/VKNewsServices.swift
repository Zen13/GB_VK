//
//  VKNewsServices.swift
//  GB_VK
//
//  Created by Zen on 16.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import RealmSwift

class VKNewsServices {
    
    let servicesRequestSetting = VKServices()
    
    typealias loadNewsDataCompletion = () -> Void
    
    func loadNews(completion: @escaping ([News]) -> Void) {
        let path = "method/newsfeed.get?v=5.68"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "return_banned" : 0,
            "max_photos": 3,
            //"start_time" : 1508112000,
            "count": 15,
            "filters": "post"
        ]
        
        let url = servicesRequestSetting.baseURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] respons in
            guard let data = respons.value else { return }
            let json = JSON(data)
            let news = json["response"]["items"].flatMap { News(json: $0.1) }
            //self?.saveNewsData(news)
            completion(news)
        }
        
    }
    
    func wallPost(owner_id: String, message: String, local: (lat: Double, long: Double),  completion: @escaping loadNewsDataCompletion) {
        let path = "method/wall.post?v=5.69"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "owner_id" : owner_id,
            "message": message,
            "lat": local.lat,
            "long": local.long
        ]
        
        let url = servicesRequestSetting.baseURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { [weak self] respons in
            guard let data = respons.value else { return }
            let json = JSON(data)
            //let news = json["response"]["items"].flatMap { News(json: $0.1) }
            //self?.saveNewsData(news)
            completion()
        }
        
    }
    
    func saveNewsData(_ news: [News]) {
        
        do {
            let realm = try Realm()
            let oldNews = realm.objects(News.self)
            
            realm.beginWrite()
            realm.delete(oldNews)
            //print(realm.configuration.fileURL)
            realm.add(news)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
