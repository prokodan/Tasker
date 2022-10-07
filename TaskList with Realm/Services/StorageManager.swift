//
//  StorageManager.swift
//  TaskList with Realm
//
//  Created by Данил Прокопенко on 06.10.2022.
//

import Foundation
import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    let realm = try! Realm()
    
    private init() {}
    
    //MARK: - TaskList
    func save(_ taskLists: [TaskList]) {
        write {
            realm.add(taskLists)
        }
    }
    
    func save(_ taskList: TaskList) {
        write {
            realm.add(taskList)
        }
    }
    
    func delete(_ taskList: TaskList) {
        write {
            realm.delete(taskList)
        }
    }
    
    func edit(_ taskList: TaskList, newValue: String) {
        write {
            taskList.name = newValue
        }
    }
    
    func done(_ taskList: TaskList) {
        write {
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    //MARK: - Task
    
    func save(_ task: Task, to taskList: TaskList) {
        write {
            taskList.tasks.append(task)
        }
    }
    
    func delete(_ task: Task) {
        write {
            realm.delete(task)
        }
    }
    
    func edit(_ task: Task, toNewName name: String, toNewNote note: String ) {
        write {
            task.name = name
            task.note = note
        }
    }
    
    func done(_ task: Task) {
        write {
            task.isComplete.toggle()
        }
    }
    
    
    
    //MARK: - realmWrite
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
