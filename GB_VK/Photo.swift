//
//  Photo.swift
//  GB_VK
//
//  Created by Zen on 28.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var album_id = 0
    @objc dynamic var owner_id = 0
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    @objc dynamic var date = 0
    @objc dynamic var photo_75 = ""
    @objc dynamic var photo_2560 = ""
    
    convenience init(json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.album_id = json["album_id"].intValue
        self.owner_id = json["owner_id"].intValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.photo_75 = json["photo_75"].stringValue
        self.photo_2560 = json["photo_2560"].stringValue
        self.date = json["date"].intValue
    }
    
}
