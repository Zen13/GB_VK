//
//  VKLoginServices.swift
//  GB_VK
//
//  Created by Zen on 30.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import WebKit

class VKLoginService{
    
    func getrequest() -> URLRequest{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "6197699"), //6196172
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "friends,photos,groups, wall"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        return request
    }
    
}
