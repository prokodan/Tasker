//
//  Extension + AlertController.swift
//  TaskList with Realm
//
//  Created by Данил Прокопенко on 06.10.2022.
//

import UIKit

extension UIAlertController {
    
    static func createAlert(withTitle title: String, andMessage message: String) -> UIAlertController {
        UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    func action(with taskList: TaskList?, completion: @escaping (String) -> Void) {
        
        let doneButton = taskList == nil ? "Save" : "Update"
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else {return}
            guard !newValue.isEmpty else {return}
            completion(newValue)
        }
        
        let canelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(canelAction)
        addTextField { textField in
            textField.placeholder = "List Name"
            textField.text = taskList?.name
        }
        
    }
    
    
}
