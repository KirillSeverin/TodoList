//
//  TaskListInteractorProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation
import CoreData

protocol TaskListInteractorProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func fetchInitialTasksIfNeeded()
    func saveTasksToDataBase(_ todos: [TaskModel])
    func setupFetchedResultsController(delegate: NSFetchedResultsControllerDelegate)
    func fechTasks() -> [TaskEntity]
    func task(at indexPath: IndexPath) -> TaskEntity
    func deleteTask(at indexPath: IndexPath)
    func toggleTaskStatus(at indexPath: IndexPath)
    func searchTasks(query: String?)
}
