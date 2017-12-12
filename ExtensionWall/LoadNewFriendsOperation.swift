//
//  LoadNewFriendsOperation.swift
//  ExtensionWall
//
//  Created by Zen on 30.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class LoadNewFriendsOperation: AsyncNetworkOperation {
    var userName: String?
    var userLocation: String?
    
    private var userIDs = ""
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    lazy var url: URL? = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/users.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "user_ids", value: userIDs),
            URLQueryItem(name: "fields", value: "city, screen_name, photo_200"),
            URLQueryItem(name: "access_token", value: KeychainWrapper.standard.string(forKey: "usersToken")),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request.url
    }()
    
    // MARK: - Overriden
    
    override func main() {
        guard let loadFriendsRequestsIDOperation = dependencies.first as? LoadFriendsRequestsIDOperation else {
            print("LoadNewFriendsOperation finished with no or wrong dependencies")
            self.state = .finished
            return
        }
        
        guard let userIDs = loadFriendsRequestsIDOperation.userIDs else {
            print("LoadNewFriendsOperation finished with no userIDs")
            return
        }
        
        self.userIDs = userIDs
        
        guard let url = url else {
            assertionFailure()
            return
        }
        
        session.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            if let error = error {
                print("LoadNewFriendsOperation failed:\(error.localizedDescription)")
                self?.state = .finished
                return
            }
            
            guard let data = data else {
                assertionFailure()
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                var dict = json as! [String : Any]
                let array = dict["response"] as! [Any]
                dict = array.first as! [String : Any]
                let city = dict["city"] as! [String : Any]
                self?.userLocation = (city["title"] as! String)
                let name = dict["first_name"] as! String
                let lastName = dict["last_name"] as! String
                self?.userName = name + " " + lastName
            } catch {
                print("LoadFriendsRequestsIDOperation failed:\(error.localizedDescription)")
            }
            self?.state = .finished
        }).resume()
    }
}
