//
//  TaskListInteractor.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit
import CoreData

final class TaskListInteractor: TaskListInteractorProtocol {
    
    weak var presenter: TaskListPresenterProtocol?
    private let taskRepository: TaskRepositoryProtocol
    private var fetchedResultsController: NSFetchedResultsController<TaskEntity>!
    
    init(taskRepository: TaskRepositoryProtocol = TaskRepository()) {
        self.taskRepository = taskRepository
    }
    
    func fetchInitialTasksIfNeeded() {
        if UserDefaults.standard.bool(forKey: "isDataLoaded") { return }
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https://dummyjson.com/todos") else { return }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(DummyTodos.self, from: data)
                        self.saveTasksToDataBase(decoded.todos)
                        UserDefaults.standard.set(true, forKey: "isDataLoaded")
                        print(DummyTodos(todos: decoded.todos))
                    } catch {
                        print("Error decoding:", error)
                    }
                }
            }.resume()
        }
        DispatchQueue.main.async {
            self.presenter?.didLoadInitialTasks()
        }
    }
    
    func saveTasksToDataBase(_ todos: [TaskModel]) {
        taskRepository.saveTasksToDataBase(todos)
    }
    
    func setupFetchedResultsController(delegate: NSFetchedResultsControllerDelegate) {
        fetchedResultsController = taskRepository.makeFetchedResultsController(delegate: delegate)
    }
    
    func fechTasks() -> [TaskEntity] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    func task(at indexPath: IndexPath) -> TaskEntity {
        fetchedResultsController.object(at: indexPath)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let task = fetchedResultsController.object(at: indexPath)
        taskRepository.deleteTask(task)
    }
    
    func toggleTaskStatus(at indexPath: IndexPath) {
        let task = fetchedResultsController.object(at: indexPath)
        taskRepository.toggleTaskStatus(task, isCompleted: task.isCompleted)
        DispatchQueue.main.async {
            self.presenter?.didLoadInitialTasks()
        }
    }
    
    func searchTasks(query: String?) {
        let context = fetchedResultsController.managedObjectContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        if let query = query, !query.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        }
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = presenter as? NSFetchedResultsControllerDelegate
        try? fetchedResultsController.performFetch()
        presenter?.didLoadInitialTasks()
    }
}

struct DummyTodos: Codable {
    let todos: [TaskModel]
}
