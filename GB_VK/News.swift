//
//  News.swift
//  GB_VK
//
//  Created by Zen on 16.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class News: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var text = ""
    @objc dynamic var textRepost = ""
    @objc dynamic var newsMainImg = ""
    @objc dynamic var source_id = ""
    @objc dynamic var itIsRepost = false
    @objc dynamic var owner_id = ""
    

    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(json: JSON) {
        self.init()
        self.id = json["source_id"].stringValue + "_" + json["post_id"].stringValue
        self.text = json["text"].stringValue
        self.source_id = json["source_id"].stringValue
        for (_, attachment) in json["attachments"] {
            if attachment["type"].stringValue == "photo" {
                self.newsMainImg = attachment["photo"]["photo_130"].stringValue
            }
        }
        
        let copy_history = json["copy_history"].arrayValue
        
        if copy_history.count > 0  {
            self.itIsRepost = true
            self.owner_id = copy_history[0]["owner_id"].stringValue
            if let textRepost = copy_history[0]["text"].rawString() {
                self.textRepost = textRepost
            }
        }
        
    }
}
