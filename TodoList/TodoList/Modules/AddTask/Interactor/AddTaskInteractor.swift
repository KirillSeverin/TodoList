//
//  AddTaskInteractor.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

final class AddTaskInteractor: AddTaskInteractorProtocol {
    
    weak var presenter: AddTaskPresenterProtocol?
    private let taskRepository: TaskRepositoryProtocol
    
    init(taskRepository: TaskRepositoryProtocol = TaskRepository()) {
        self.taskRepository = taskRepository
    }
    
    func addTask(title: String, description: String) {
        taskRepository.addTask(title: title, desc: description)
        presenter?.didSaveTask()
    }
}
