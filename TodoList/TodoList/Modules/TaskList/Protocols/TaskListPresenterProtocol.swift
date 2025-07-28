//
//  TaskListPresenterProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didLoadInitialTasks()
    func numberOfTasks() -> Int
    func task(at indexPath: IndexPath) -> TaskEntity
    func didTapAddTask(from view: UIViewController)
}
