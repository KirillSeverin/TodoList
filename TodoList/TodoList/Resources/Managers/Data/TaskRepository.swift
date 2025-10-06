//
//  TaskRepository.swift
//  TodoList
//
//  Created by Kirill Severin on 1.10.25.
//

import Foundation
import CoreData

protocol TaskRepositoryProtocol {
    func addTask(title: String, desc: String)
    func updateTask(_ task: TaskEntity, title: String, desc: String)
    func toggleTaskStatus(_ task: TaskEntity, isCompleted: Bool)
    func saveTasksToDataBase(_ todos: [TaskModel])
    func deleteTask(_ task: TaskEntity)
    func makeFetchedResultsController(delegate: NSFetchedResultsControllerDelegate?) -> NSFetchedResultsController<TaskEntity>
}

final class TaskRepository: TaskRepositoryProtocol {
    
    private let coreDataManager = CoreDataManager.shared
    
    func addTask(title: String, desc: String) {
        let task = TaskEntity(context: coreDataManager.viewContext)
        task.title = title
        task.desc = desc
        task.date = Date()
        task.isCompleted = false
        coreDataManager.saveContext(task.managedObjectContext)
    }
    
    func updateTask(_ task: TaskEntity, title: String, desc: String) {
        guard let context = task.managedObjectContext else {
            print("TaskEntity не привязан к context")
            return
        }
        task.title = title
        task.desc = desc
        coreDataManager.saveContext(context)
    }
    
    func deleteTask(_ task: TaskEntity) {
        guard let context = task.managedObjectContext else {
            print("TaskEntity не привязан к context")
            return
        }
        context.delete(task)
        coreDataManager.saveContext(context)
    }
    
    func toggleTaskStatus(_ task: TaskEntity, isCompleted: Bool) {
        task.isCompleted = !isCompleted
        coreDataManager.saveContext(task.managedObjectContext)
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
    
    //MARK: - FetchedResultsController
    
    func makeFetchedResultsController(
        delegate: NSFetchedResultsControllerDelegate?
    ) -> NSFetchedResultsController<TaskEntity> {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title",
                                                        ascending: true)]
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataManager.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        frc.delegate = delegate
        try? frc.performFetch()
        return frc
    }
}
