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
    
    init(taskRepository: TaskRepositoryProtocol = TaskRepository()) {
        self.taskRepository = taskRepository
    }
    
    func fetchInitialTasksIfNeeded() {
        if UserDefaults.standard.bool(forKey: "isDataLoaded") { return }
        
        DispatchQueue.global().async {
            guard let url = URL(string: "https://dummyjson.com/todos") else { return }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(DummyTodos.self, from: data)
                        self.saveTasksToDataBase(decoded.todos)
                        print(DummyTodos(todos: decoded.todos))
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(true, forKey: "isDataLoaded")
                            self.presenter?.didLoadInitialTasks()
                        }
                    } catch {
                        print("Error decoding:", error)
                    }
                }
            }.resume()
        }
    }
    
    private func saveTasksToDataBase(_ todos: [TaskModel]) {
        taskRepository.saveTasksToDataBase(todos)
    }
}

struct DummyTodos: Codable {
    let todos: [TaskModel]
}
