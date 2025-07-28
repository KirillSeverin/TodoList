//
//  TaskListPresenter.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

final class TaskListPresenter: TaskListPresenterProtocol {
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    func viewDidLoaded() {
        interactor?.fetchInitialTasksIfNeeded()
    }
    
    func didLoadInitialTasks() {
        view?.reloadTasks()
    }
}
