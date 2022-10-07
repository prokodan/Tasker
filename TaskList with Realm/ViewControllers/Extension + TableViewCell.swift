//
//  Extension + TableViewCell.swift
//  TaskList with Realm
//
//  Created by Данил Прокопенко on 06.10.2022.
//

import UIKit

extension UITableViewCell {
    
    func configure(with taskList: TaskList) {
        let currentTasks = taskList.tasks.filter("isComplete = false")
        var content = defaultContentConfiguration()
        
        content.text = taskList.name
        
        if taskList.tasks.isEmpty {
            content.secondaryText = "0"
            accessoryType = .none
        } else if currentTasks.isEmpty{
            content.secondaryText = nil
            accessoryType = .checkmark
        } else {
            content.secondaryText = "\(currentTasks.count)"
            accessoryType = .none
        }
        
        contentConfiguration = content
    }
    
}
