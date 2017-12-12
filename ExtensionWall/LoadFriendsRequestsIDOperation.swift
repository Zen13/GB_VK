//
//  GetFriendsRequests.swift
//  ExtensionWall
//
//  Created by Zen on 29.11.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class LoadFriendsRequestsIDOperation: AsyncNetworkOperation {
    
    var userIDs: String?
    var count = 0
    
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    lazy var url: URL? = {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.getRequests"
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: KeychainWrapper.standard.string(forKey: "usersToken")),
            URLQueryItem(name: "v", value: "5.68")
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request.url
    }()
    
    // MARK: - Overriden
    
    override func main() {
        guard let url = url else {
            assertionFailure()
            return
        }
        session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("LoadFriendsRequestsIDOperation failed:\(error.localizedDescription)")
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
                dict = try dict["response"] as! [String : Any]
                let items = dict["items"] as! [Int]
                self?.userIDs = String(items.map{String($0)}.joined(separator: ","))
                self?.count = dict["count"] as! Int
            } catch {
                print("LoadFriendsRequestsIDOperation failed:\(error.localizedDescription)")
            }
            self?.state = .finished
            }.resume()
    }
    
}
