//
//  DataManager.swift
//  TaskList with Realm
//
//  Created by Данил Прокопенко on 06.10.2022.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}

    func createTempData(completion: @escaping() -> Void) {
//        UserDefaults.standard.set(true, forKey: "done")

        if !UserDefaults.standard.bool(forKey: "done") {
            let shoppingList = TaskList()
            shoppingList.name = "Shopping List"

            let moviesList = TaskList(
                value: ["Movies List",
                        Date(),
                        [
                            ["Terminator"],
                            ["Inception", "Watch with...", Date(), true]
                        ]
                       ]
            )

            let milk = Task()
            milk.name = "Milk"
            milk.note = "1L"

            let bread = Task(value: ["Bread", "", Date(), true])
            let apples = Task(value: ["name": "Apples", "note": "2Kg"])

            shoppingList.tasks.append(milk)
            shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)

            DispatchQueue.main.async {
                StorageManager.shared.save([shoppingList, moviesList])
                UserDefaults.standard.set(true, forKey: "done")
                completion()
            }
        }
    }
}
