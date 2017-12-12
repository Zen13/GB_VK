//
//  SetImageToCell.swift
//  GB_VK
//
//  Created by Zen on 26.10.17.
//  Copyright © 2017 Zen. All rights reserved.
//

import UIKit

class SetImageToCell: Operation {
    private let indexPath: IndexPath
    private weak var collectionView: UITableView?
    
    init(indexPath: IndexPath, collectionView: UITableView) {
        self.indexPath = indexPath
        self.collectionView = collectionView
    }
    
    override func main() {
        guard let collectionView = collectionView,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
 
        if let cell = collectionView.cellForRow(at: indexPath) as? FriendsTableViewCell {
            cell.avatar.image = image
        } else if let cell = collectionView.cellForRow(at: indexPath) as? MyGroupTableViewCell  {
            cell.avatar.image = image
        }
        
    }
}

