//
//  NewsVC.swift
//  GB_VK
//
//  Created by Zen on 16.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
//import AlammofireI

class NewsVC: UITableViewController {

    let newsServices = VKNewsServices()
    let imageServices = VKImageServices()
    let userServices = VKUserServices()
    let groupServices = VKGroupServices()
    
    var news = [News]()
    var token: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsServices.loadNews() { [weak self] news in
            self?.news = news
            self?.tableView?.reloadData()
            
        }
//        pairTableAndRealm()
//        newsServices.loadNews() { [weak self] in
//            self?.loadData()
//            self?.tableView?.reloadData()
//        }
    }

//    func loadData() {
//        do {
//            let realm = try Realm()
//            let news = realm.objects(News.self)
//            self.news = news
//        } catch {
//            print(error)
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
//
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        let oneNews = news[indexPath.row]
//            cell.newsText.text = ""
//            cell.newsMainImg.image = #imageLiteral(resourceName: "imgNotFound.png")
//            return cell
        
        cell.newsText.text = oneNews.text
        imageServices.loadImage(url: oneNews.newsMainImg) {img in
            cell.newsMainImg.image = img
        }
        
//        if oneNews.newsMainImg == "" {
//            cell.newsMainImg.isHidden = true
//        } else {
//            cell.newsMainImg.isHidden = false
//        }
        
        // получим информацию об источнике
        if let firstSimbol = oneNews.source_id.first {
            if firstSimbol == "-" {
                groupServices.loadGroupInfo(group_id: oneNews.source_id) {  [weak self] groups in
                    if groups.count > 0 {
                        let group = groups[0]
                        
                        cell.newsAutorName.text = group.name
                        
                        self?.imageServices.loadImage(url: group.photo_50) {img in
                            cell.newsAutorAvatar.image = img
                        }
                    }
                        
                }
            } else {
                userServices.loadUserInfo(user_id: oneNews.source_id) { [weak self] userArray in
                    if userArray.count > 0 {
                        let user = userArray[0]
                        
                        cell.newsAutorName.text = user.fullName
                        
                        self?.imageServices.loadImage(url: user.photo_50) {img in
                            cell.newsAutorAvatar.image = img
                        }
                    }
                }
            }
        } else {
            cell.newsAutorName.text = ""
            cell.newsAutorAvatar.image = #imageLiteral(resourceName: "imgNotFound.png")
        }
//        if cell.newsMainImg.image == #imageLiteral(resourceName: "imgNotFound") {
//            cell.newsMainImg.isHidden = true
//        }
        return cell
    }
    
//    func pairTableAndRealm() {
//
//        guard let realm = try? Realm() else { return }
//        news = realm.objects(News.self)
//        token = news?.observe { [weak self] (changes: RealmCollectionChange) in
//            guard let tableView = self?.tableView else { return }
//
//            switch changes {
//            case .initial:
//                tableView.reloadData()
//            case .update(_, let deletions, let insertions, let modifications):
//                tableView.beginUpdates()
//                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .none)
//                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                     with: .none)
//                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                     with: .none)
//                tableView.endUpdates()
//            case .error(let error):
//                fatalError("\(error)")
//                break
//            }
//        }
//    }
    
    @IBAction func myAction(unwindSegue: UIStoryboardSegue) {
        let a = 1
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
