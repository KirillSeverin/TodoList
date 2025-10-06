//
//  EditTaskInteractor.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import Foundation
import CoreData

final class EditTaskInteractor: EditTaskInteractorProtocol {
    
    weak var presenter: EditTaskInteractorOutputProtocol?
    private let taskRepository: TaskRepositoryProtocol
    
    init(taskRepository: TaskRepositoryProtocol = TaskRepository()) {
        self.taskRepository = taskRepository
    }
    
    func updateTask(task: TaskEntity, title: String, description: String) {
        taskRepository.updateTask(task, title: title, desc: description)
        presenter?.taskSaved()
    }
}
