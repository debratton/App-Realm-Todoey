//
//  SwipeTVC.swift
//  Todoey
//
//  Created by David E Bratton on 11/4/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTVC: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            if let deleteCategory = self.categories {
//                let itemToDelete = deleteCategory[indexPath.row]
//                self.delete(category: itemToDelete)
//            }
            print("Delete Cell")
        }
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        
        return options
    }
}
