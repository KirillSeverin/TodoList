//
//  TaskRepository.swift
//  TodoList
//
//  Created by Kirill Severin on 1.10.25.
//

import Foundation

protocol TaskRepositoryProtocol {
    func addTask(title: String, desc: String)
    func updateTask(_ task: TaskEntity, title: String, desc: String)
    func saveTasksToDataBase(_ todos: [TaskModel])
}

final class TaskRepository: TaskRepositoryProtocol {
    
    private let coreDataManager = CoreDataManager.shared
    
    func addTask(title: String, desc: String) {
        let task = TaskEntity(context: coreDataManager.viewContext)
        task.title = title
        task.desc = desc
        task.date = Date()
        task.isCompleted = false
        coreDataManager.saveContext()
    }
    
    func updateTask(_ task: TaskEntity, title: String, desc: String) {
        guard let context = task.managedObjectContext else {
            print("TaskEntity не привязан к контексту")
            return
        }
        task.title = title
        task.desc = desc
        task.date = Date()
        task.isCompleted = false
        coreDataManager.saveContext(context)
    }
    
    func saveTasksToDataBase(_ todos: [TaskModel]) {
        let context = coreDataManager.viewContext
        todos.forEach { task in
            let entity = TaskEntity(context: context)
            entity.id = Int64(task.id)
            entity.title = task.todo
            entity.desc = task.description
            entity.isCompleted = task.completed
            entity.date = Date()
        }
        coreDataManager.saveContext()
    }
}
