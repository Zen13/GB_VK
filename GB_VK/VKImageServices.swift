//
//  VKImageServices.swift
//  GB_VK
//
//  Created by Zen on 02.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import RealmSwift

class VKImageServices {
    
    let servicesRequestSetting = VKServices()
    
    private let syncQueue = DispatchQueue(label: "ru.zen.vkimageservices", qos: .userInteractive)
    
    typealias loadOnePhotoDataCompletion = (UIImage) -> Void
    typealias loadPhotosDataCompletion = ([Photo]) -> Void
    
    func loadImage(url: String, completion: @escaping loadOnePhotoDataCompletion) {
        guard let remoteImageURL = URL(string: url) else {
            completion(#imageLiteral(resourceName: "imgNotFound"))
            return
        }
        
        //Alamofire.request(remoteImageURL).responseData(queue: syncQueue) { (response) in
        Alamofire.request(remoteImageURL).responseData() { (response) in
            if response.error == nil {
                if let data = response.data {
                    let img = UIImage(data: data)!
                    completion(img)
                }
            }
        }
    }
    
    func loadAllPhoto(user_id: Int, completion: @escaping loadPhotosDataCompletion) {
        let path = "method/photos.getAll?v=5.68"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "extended" : 1,
            "owner_id" : user_id,
            "count" : 5
        ]
        
        let url = servicesRequestSetting.baseURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON() {respons in
            guard let data = respons.value else { return }
            let json = JSON(data)
            let photos = json["response"]["items"].flatMap { Photo(json: $0.1) }
            //self?.savePhotoData(photos)
            completion(photos)
        }
        
    }
    
//    func savePhotoData(_ photos: [Photo]) {
//
//        do {
//            let realm = try Realm()
//            let oldPhoto = realm.objects(Photo.self)
//
//            realm.beginWrite()
//            realm.delete(oldPhoto)
//            print(realm.configuration.fileURL)
//            realm.add(photos)
//            try realm.commitWrite()
//        } catch {
//            print(error)
//        }
//    }
    
}
