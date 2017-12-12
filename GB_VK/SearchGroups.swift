//
//  SearchGroups.swift
//  GB_VK
//
//  Created by Zen on 21.09.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit
import  FirebaseDatabase


struct  SerchGroupForDataBase  {
    let  name:  String
    var  toAnyObject:  Any  {
        return  [
            "name" :  name
        ]
    }
}

class SearchGroups: UITableViewController {

    let rezultSearchGroup = VKGroupServices()
    let imageServices = VKImageServices()
    
    var groups = [Group]()
    
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroupsCell", for: indexPath) as! SearchGroupsCell
        let group = groups[indexPath.row]
        
        cell.name.text = group.name
        
        imageServices.loadImage(url: group.photo_50) {img in
            cell.avatar.image = img
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gruopForDatabase = SerchGroupForDataBase(name: groups[indexPath.row].name)
        let data = [gruopForDatabase].map{  $0.toAnyObject  }
        
        let dbLink = Database.database().reference()
        dbLink.child("SearchGroup").setValue(data)
        
        rezultSearchGroup.joinToGroup(groupID: groups[indexPath.row].id) { [weak self] in
            self?.performSegue(withIdentifier: "addGroup", sender: nil)
        }
    }
    
}

extension SearchGroups: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard
            let text = searchBar.text,
            !text.isEmpty else {

                tableView.reloadData()
                return
        }
        searchGroups(request: text)
        tableView.reloadData()
    }

    func searchGroups(request: String) {
        rezultSearchGroup.searchGroup(seqrchText: request) { [weak self] groups in
            self?.groups = groups
            self?.tableView?.reloadData()
        }
    }
}

