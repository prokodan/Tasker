//
//  TaskViewController.swift
//  TaskList with Realm
//
//  Created by Данил Прокопенко on 06.10.2022.
//

import UIKit
import RealmSwift

class TaskViewController: UITableViewController {
    
    //MARK: - Public Properties
    var taskList: TaskList!
    
    //MARK: - Private Properties
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    //MARK: - VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskList.name
        fillTaskArrays()
        setupBarButtonItems()
        setupNavBarappearance()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : completedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Current Tasks" : "Completed Tasks"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Tasks.taskCell.rawValue, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        content.text = task.name
        content.secondaryText = task.note
        cell.contentConfiguration = content
        
        return cell
    }

    //MARK: - TableViewDelegate Methods
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = indexPath.section == 0
        ? currentTasks[indexPath.row]
        : completedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(with: task) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneTitle = indexPath.section == 0 ? "Done" : "Undone"
        let doneAction = UIContextualAction(style: .normal, title: doneTitle) { _, _, isDone in
            StorageManager.shared.done(task)
            let indexPathForCurrentTask = IndexPath(
                row: self.currentTasks.index(of: task) ?? 0,
                section: 0
            )
            let indexPathForCompletedTask = IndexPath(
                row: self.completedTasks.index(of: task) ?? 0,
                section: 1
            )
            let destinationIndexRow = indexPath.section == 0 ? indexPathForCompletedTask : indexPathForCurrentTask
            tableView.moveRow(at: indexPath, to: destinationIndexRow)
            isDone(true)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = indexPath.section == 0
        ? currentTasks[indexPath.row]
        : completedTasks[indexPath.row]

        StorageManager.shared.done(task)
        let indexPathForCurrentTask = IndexPath(
            row: self.currentTasks.index(of: task) ?? 0,
            section: 0
        )
        let indexPathForCompletedTask = IndexPath(
            row: self.completedTasks.index(of: task) ?? 0,
            section: 1
        )
        let destinationIndexRow = indexPath.section == 0 ? indexPathForCompletedTask : indexPathForCurrentTask
        tableView.moveRow(at: indexPath, to: destinationIndexRow)
    }
    
    //MARK: - Private Methods
    private func setupNavBarappearance() {
        let inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.contentInset = inset
    }
    
    private func fillTaskArrays() {
        currentTasks = taskList.tasks.filter("isComplete = false")
        completedTasks = taskList.tasks.filter("isComplete = true")
    }
    
    private func setupBarButtonItems() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed)
        )
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
}

    //MARK: - Extension TaskViewController
extension TaskViewController {
    
    /// Showing alert for new or update task event depending on an optional  parameters
    /// - Parameters:
    ///   - task: in case of no task value new task alertController will be shown
    ///   - completion: in case of no completion value new task alertController will be shown
    private func showAlert(with task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Edit Task" : "New Task"
        
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "What do you want to add?")
        
        alert.action(with: task) { newTask, note in
            if let task = task, let completion = completion {
                StorageManager.shared.edit(task, toNewName: newTask, toNewNote: note)
                completion()
            } else {
                self.saveTask(withName: newTask, andNote: note)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func saveTask(withName name: String, andNote note: String) {
        let task = Task(value: [name, note])
        StorageManager.shared.save(task, to: taskList)
        let rowIndex = IndexPath(row: currentTasks.index(of: task) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
}
