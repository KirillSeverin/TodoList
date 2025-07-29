//
//  AddTaskPresenter.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

final class AddTaskPresenter: AddTaskPresenterProtocol {
    
    weak var view: AddTaskViewProtocol?
    var interactor: AddTaskInteractorProtocol?
    var router: AddTaskRouterProtocol?
    var editingTask: TaskEntity?
    
    func didTapSave(title: String?, description: String?) {
        if let task = editingTask {
            task.title = title
            task.desc = description ?? ""
            interactor?.saveTask(title: task.title ?? "", description: task.description)
        }
        guard let title = title, !title.isEmpty else {
            view?.showError("Title is required")
            return
        }
        interactor?.saveTask(title: title, description: description ?? "")
    }
    
    func didSaveTask() {
        view?.dismissView()
    }
    
}
