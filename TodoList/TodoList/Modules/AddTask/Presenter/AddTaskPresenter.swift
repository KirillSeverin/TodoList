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
    
    func didTapSave(title: String?, description: String?) {
        guard let title = title, !title.isEmpty else {
            view?.showError("Заголовок обязателен")
            return
        }
        interactor?.saveTask(title: title, description: description ?? "")
    }
    
    func didSaveTask() {
        view?.dismissView()
    }
    
}
