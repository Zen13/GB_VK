//
//  LoginViewController.swift
//  GB_VK
//
//  Created by Zen on 30.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import SwiftKeychainWrapper


class LoginViewController: UIViewController {

    @IBOutlet weak var webLoginView: WKWebView!{
        didSet {
            webLoginView.navigationDelegate = self
        }
    }
    
    var service = VKLoginService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webLoginView.load(service.getrequest())

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webLoginView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment  else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        //print(params)
        
        let token = params["access_token"]
        
        // в зашифрованном виде сохраним usersToken
        KeychainWrapper.standard.set(token!, forKey: "usersToken")
        
        // в незашифрованном виде сохраним user_id текущего пользователя
        if let user_id = params["user_id"] {
            let userDefaults = UserDefaults.standard
            userDefaults.set(user_id, forKey: "user_id")
        }else {
            // вывести сообщение об ошибке
        }
        
        decisionHandler(.cancel)
        
        performSegue(withIdentifier: "toLoginPage", sender: token)
    }

}
