//
//  User.swift
//  GB_VK
//
//  Created by Zen on 28.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class User: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var first_name = ""
    @objc dynamic var last_name = ""
    @objc dynamic var sex = 0
    @objc dynamic var domain = ""
    @objc dynamic var photo_50 = ""
    @objc dynamic var photo_100 = ""
    @objc dynamic var photo_200_orig = ""
    var counters = [String: Int]()
    
    var fullName: String {
        return first_name + " " + last_name
    }
    
    override static func primaryKey()-> String?{
        return "id"
    }
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.first_name = json["first_name"].stringValue
        self.last_name = json["last_name"].stringValue
        self.sex = json["sex"].intValue
        self.domain = json["domain"].stringValue
        self.photo_50 = json["photo_50"].stringValue
        self.photo_100 = json["photo_100"].stringValue
        self.photo_200_orig = json["photo_200_orig"].stringValue
        let countersJson = json["counters"].dictionaryValue

        for elem in countersJson {
            self.counters[elem.key] = elem.value.intValue
        }
    }
}
