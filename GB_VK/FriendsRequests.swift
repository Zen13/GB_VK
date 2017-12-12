//
//  FriendsRequests.swift
//  GB_VK
//
//  Created by Zen on 20.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class FriendsRequests: Object {
    
    @objc dynamic var id = 0
    
    override static func primaryKey()-> String?{
        return "id"
    }
    convenience init(json: JSON) {
        self.init()
        self.id = json["user_id"].intValue
    }
    
}
