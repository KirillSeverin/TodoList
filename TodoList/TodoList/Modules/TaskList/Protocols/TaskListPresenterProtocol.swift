//
//  TaskListPresenterProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didLoadInitialTasks()
    func numberOfTasks() -> Int
    func task(at indexPath: IndexPath) -> TaskEntity
    func didTapAddTask(from view: UIViewController)
    func searchTextChanged(_ text: String?)
    func editTask(at indexPath: IndexPath, from view: UIViewController)
    func deleteTask(at indexPath: IndexPath)
    func toggleTaskStatus(at indexPath: IndexPath)
}
