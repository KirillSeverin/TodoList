//
//  EditTaskPresenter.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import Foundation
import UIKit

final class EditTaskPresenter: EditTaskPresenterProtocol {
    
    weak var view: EditTaskViewProtocol?
    var interactor: EditTaskInteractorProtocol?
    var router: EditTaskRouterProtocol?
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var task: TaskEntity?
    
    func viewDidLoad() {
        guard let task = task else {
            return
        }
        view?.setTask(
            title: task.title,
            description: task.desc,
            date: formatter.string(from: task.date ?? Date()))
    }
    
    func didTapSave(title: String?, description: String?) {
        guard let title = title,
              !title.isEmpty else {
            view?.showError("Введите заголовок")
            return
        }
        guard let task = task else {
            return
        }
        interactor?.updateTask(task: task,
                               title: title,
                               description: description ?? "")
    }
}

extension EditTaskPresenter: EditTaskInteractorOutputProtocol {
    func taskSaved() {
        view?.dismissView()
    }
}
