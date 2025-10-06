//
//  TaskListPresenter.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import CoreData
import UIKit

final class TaskListPresenter: NSObject, TaskListPresenterProtocol {
    
    weak var view: TaskListViewProtocol?
    var router: TaskListRouterProtocol?
    var interactor: TaskListInteractorProtocol?
    
    func viewDidLoad() {
        interactor?.setupFetchedResultsController(delegate: self)
        interactor?.fetchInitialTasksIfNeeded()
    }
    
    func didLoadInitialTasks() {
        view?.reloadTasks()
    }
    
    func didTapAddTask(from view: UIViewController) {
        router?.navigateToAddTask(from: view)
    }
    
    func numberOfTasks() -> Int {
        interactor?.fechTasks().count ?? 0
    }
    
    func task(at indexPath: IndexPath) -> TaskEntity {
        guard let task = interactor?.task(at: indexPath) else {
            fatalError("Interactor не инициализирован или вернул nil")
        }
        return task
    }
    
    func editTask(at indexPath: IndexPath, from view: UIViewController) {
        guard let task = interactor?.task(at: indexPath) else {
            fatalError("Interactor не инициализирован или вернул nil")
        }
        router?.navigateToEditTask(from: view, task: task)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        interactor?.deleteTask(at: indexPath)
    }
    
    func toggleTaskStatus(at indexPath: IndexPath) {
        interactor?.toggleTaskStatus(at: indexPath)
    }
    
    func searchTextChanged(_ text: String?) {
        interactor?.searchTasks(query: text)
    }
}

extension TaskListPresenter: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        view?.reloadTasks()
    }
}
