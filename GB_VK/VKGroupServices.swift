//
//  VKGroupServices.swift
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

class VKGroupServices {

//    private let router: GroupRouter
    let servicesRequestSetting = VKServices()
    
    typealias loadGroupsDataCompletion = () -> Void
//    typealias loadGroupInfoq = ([Group]) -> Void
    typealias loadGroupsSearchDataCompletion = ([Group]) -> Void
    
//    init(environment: Environment, token: String) {
//        router = GroupRouter(environment: environment, token: token)
//    }
    
    func loadGroupList(completion: @escaping loadGroupsDataCompletion) {
        let path = "method/groups.get?v=5.52"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "extended" : 1,
            "fields" : "members_count"
        ]
        
        let url = servicesRequestSetting.baseURL + path
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON() { [weak self] respons in
            guard let data = respons.value else { return }
            let json = JSON(data)
            let groups = json["response"]["items"].flatMap { Group(json: $0.1) }
            self?.saveGroupsData(groups)
            completion()            
        }
        
    }
    
    func loadGroupInfo(group_id: String, completion: @escaping loadGroupsSearchDataCompletion) {
        
        var correctGroup_id = group_id
        if let firstSymbol = correctGroup_id.first {
            if firstSymbol == "-" {
                correctGroup_id.remove(at: correctGroup_id.startIndex)
            }
        }
        
        let path = "method/groups.getById?v=5.61"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "group_id" : correctGroup_id,
            "fields" : "name, photo_50"
        ]

        let url = servicesRequestSetting.baseURL + path

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {respons in
            guard let data = respons.value else { return }
            let json = JSON(data)
            let group = json["response"].flatMap { Group(json: $0.1) }
            //self?.saveGroupsData(groups)
            completion(group)
        }

    }
    
    func saveGroupsData(_ groups: [Group]) {
        
        do {
            let realm = try Realm()
            let oldGroups = realm.objects(Group.self)
            
            realm.beginWrite()
            realm.delete(oldGroups)
            //print(realm.configuration.fileURL)
            realm.add(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func searchGroup(seqrchText: String, completion: @escaping loadGroupsSearchDataCompletion) {
        let path = "method/groups.search?v=5.68"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "q" : seqrchText,
            "count" : 20
        ]

        let url = servicesRequestSetting.baseURL + path

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { respons in
            guard let data = respons.value else { return }
            let json = JSON(data)
            let groups = json["response"]["items"].flatMap { Group(json: $0.1) }
            completion(groups)
        }

    }
    
    func joinToGroup(groupID: Int, completion: @escaping () -> () ) {
        let path = "method/groups.join?v=5.68"
        let parameters: Parameters = [
            "access_token" : servicesRequestSetting.access_token,
            "group_id": groupID
        ]

        let url = servicesRequestSetting.baseURL + path

        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { respons in
            guard let data = respons.value else { return }
            completion()
        }
    }
}

