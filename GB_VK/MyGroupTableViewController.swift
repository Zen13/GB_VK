//
//  MyGroupTableViewController.swift
//  GB_VK
//
//  Created by Zen on 21.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit
import RealmSwift

class MyGroupTableViewController: UITableViewController {

    let groupsServices = VKGroupServices()
    let imageServices = VKImageServices()
    
    var groups: Results<Group>?
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
        groupsServices.loadGroupList() { [weak self] in
            self?.loadData()
            self?.tableView?.reloadData()
        }
    }
    
    func loadData() {
        do {
            let realm = try Realm()
            let groups = realm.objects(Group.self)
            self.groups = groups
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
        return groups?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyGroupTableViewCell", for: indexPath) as! MyGroupTableViewCell
        
        guard let group = groups?[indexPath.row] else {
            cell.name.text = ""
            cell.avatar.image = #imageLiteral(resourceName: "imgNotFound.png")
            return cell
        }

        cell.name.text = group.name
        
        // получение аватарки из кеша. Если в кеше нет, то качаем.
        let getCacheImage = GetCacheImage(url: group.photo_50, last_name: group.name) // last_name добавил себе для отладки, чтобы проанализировать как код работает
        let setImageToCell = SetImageToCell(indexPath: indexPath, collectionView: tableView)
        setImageToCell.addDependency(getCacheImage)
        queueForImage.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToCell)
        
//        imageServices.loadImage(url: group.photo_50) {img in
//            cell.avatar.image = img
//        }
        
        return cell
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            //получаем ссылку на контроллер с которого осуществлен переход
//            let SearchGroups = segue.source as! SearchGroups
//            viewDidLoad()
            tableView.reloadData()
            
            
//            if let indexPath = SearchGroups.tableView.indexPathForSelectedRow {
//
//                let group = SearchGroups.groups[indexPath.row]
//
////                if !groups.contains(group) {
////                    groups.append(group)
////                    tableView.reloadData()
////                }
//            }
            
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            //groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func pairTableAndRealm() {
        
        guard let realm = try? Realm() else { return }
        groups = realm.objects(Group.self)
        token = groups?.observe { [weak self] (changes: RealmCollectionChange) in
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

}
