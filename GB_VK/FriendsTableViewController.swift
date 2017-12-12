//
//  FriendsTableViewController.swift
//  GB_VK
//
//  Created by Zen on 21.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController {

    let friendsServices = VKFriendsServices()
    let imageServices = VKImageServices()

    var friends: Results<User>?
    var token: NotificationToken?
    
     // Очередь, в которой будем загружать изображения
    let queueForImage: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()

        friendsServices.loadFriendList() { [weak self] in
            self?.loadData()
            self?.tableView?.reloadData()
        }
        let q = 1
    }

    func loadData() {
        do {
            let realm = try Realm()
            let friends = realm.objects(User.self)
            //self.friends = Array(friends)
            self.friends = friends
        } catch {
            print(error)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell", for: indexPath) as! FriendsTableViewCell
        
        guard let friend = friends?[indexPath.row] else {
            cell.name?.text = ""
            cell.avatar.image = #imageLiteral(resourceName: "imgNotFound.png")
            return cell
        }

        cell.name.text = friend.first_name + " " + friend.last_name
        
        // получение аватарки из кеша. Если в кеше нет, то качаем.
        let getCacheImage = GetCacheImage(url: friend.photo_50, last_name: friend.last_name) // last_name добавил себе для отладки, чтобы проанализировать как код работает
        let setImageToCell = SetImageToCell(indexPath: indexPath, collectionView: tableView)
        setImageToCell.addDependency(getCacheImage)
        queueForImage.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToCell)
        
        // так раньше грузились фотографии
//        imageServices.loadImage(url: friend.photo_50) {img in
//            cell.avatar.image = img
//        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhoto", let ctrl = segue.destination as? FriendCollectionViewController, let indexpath = tableView.indexPathForSelectedRow {
            
            
            ctrl.userId = (friends?[indexpath.row].id)!
        }
    }

    func pairTableAndRealm() {
        
        guard let realm = try? Realm() else { return }
        friends = realm.objects(User.self)
        token = friends?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .none)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
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
