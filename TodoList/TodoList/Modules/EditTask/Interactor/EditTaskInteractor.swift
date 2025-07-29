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
    
    func saveTask(task: TaskEntity, title: String, description: String) {
        task.title = title
        task.desc = description
        
        do {
            let context = task.managedObjectContext
            try context?.save()
            presenter?.taskSaved()
        } catch {
            print("Ошибка при сохранении: \(error)")
        }
    }
}
