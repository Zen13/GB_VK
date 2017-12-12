//
//  Group.swift
//  GB_VK
//
//  Created by Zen on 28.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Group: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var screen_name = ""
    @objc dynamic var members_count = 0
    @objc dynamic var photo_50 = ""
    @objc dynamic var photo_100 = ""
    @objc dynamic var photo_200 = ""
    
    override static func primaryKey()-> String?{
        return "id"
    }
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.screen_name = json["screen_name"].stringValue
        self.members_count = json["members_count"].intValue
        self.photo_50 = json["photo_50"].stringValue
        self.photo_100 = json["photo_100"].stringValue
        self.photo_200 = json["photo_200"].stringValue
    }
    
}
