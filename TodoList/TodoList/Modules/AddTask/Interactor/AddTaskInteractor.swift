//
//  AddTaskInteractor.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

final class AddTaskInteractor: AddTaskInteractorProtocol {
    
    weak var presenter: AddTaskPresenterProtocol?
    
    func saveTask(title: String, description: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let task = TaskEntity(context: context)
        task.title = title
        task.desc = description
        task.date = Date()
        task.isCompleted = false
        try? context.save()
        presenter?.didSaveTask()
    }
}
