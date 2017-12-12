//
//  LoginFormController.swift
//  GB_VK
//
//  Created by Zen on 14.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit
import Alamofire
import VK_ios_sdk
import SwiftKeychainWrapper

var access_Token: String = ""

class LoginFormController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!

    @IBAction func authorizedVKButton(_ sender: Any) {
        VKSdk.initialize(withAppId: appId).register(self)
        VKSdk.instance().uiDelegate = self
        scope = [VK_PER_GROUPS, VK_PER_FRIENDS, VK_PER_PHOTOS, VK_PER_WALL]
        
        VKSdk.wakeUpSession(scope, complete: { (state, error) in
            if (state ==  VKAuthorizationState.authorized) {
                self.startWork()
//                print("wakeUpSession")
            } else {
                VKSdk.authorize(self.scope)
//                print("NO")
            }
        })
        
    }
    
    let segueAuthorized = "goToTabBar"
    let appId = "6197699"
    var scope = [Any]()
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.navigationController?.topViewController?.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        let vc = VKCaptchaViewController.captchaControllerWithError(captchaError)
        vc?.present(in: self.navigationController?.tabBarController)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        access_Token = result.token.accessToken
        
        if (access_Token != nil) {
            print("TOKEN", access_Token)
            
            
            // в зашифрованном виде сохраним usersToken
            let token = access_Token
            KeychainWrapper.standard.set(token, forKey: "usersToken")
            // сохраним user_id
            let userDefaults = UserDefaults.standard
            userDefaults.set(result!.token.userId!, forKey: "user_id")
            
            self.startWork()
//            print("authorization")
        } else {
//            print("no authorization")
        }
    }
    
    
    
//    // в незашифрованном виде сохраним user_id текущего пользователя
//    if let user_id = params["user_id"] {
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(user_id, forKey: "user_id")
//    }else {
//    // вывести сообщение об ошибке
//    }
    
    func vkSdkUserAuthorizationFailed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func startWork() {
        performSegue(withIdentifier: segueAuthorized, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        //присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        
        authorizedVKButton(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let login = loginView.text!
        
        let password = passwordView.text!
        
        //проверяем верны ли они
        if login == "admin" && password == "123456" {
            print("успешная авторизация")
        } else {
            print("неуспешная авторизация")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func keyboardWasShown(notification: Notification) {
        
        //получем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        
        //Добавляем отсуп внизу UIScrollView равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        //устанавливаем отступ внизу UIScrollView равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "afterLogin" {
//            return true
            let checkResult = checkUserData()
            
            if !checkResult {
                showLoginError()
            }
            
            return checkResult
            
        } else {
            return true
        }
        
    }
    
    
    func checkUserData() -> Bool {
        
        let login = loginView.text!
        
        let password = passwordView.text!
        
        if login == "admin" && password == "123456" {
            return true
        } else {
            return false
        }
        
    }
    
    
    func showLoginError() {
        
        let alert = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }


}
