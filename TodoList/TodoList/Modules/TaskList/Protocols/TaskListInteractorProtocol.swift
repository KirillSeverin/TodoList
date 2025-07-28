//
//  TaskListInteractorProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    var presenter: TaskListPresenterProtocol? { get set }
    func fetchInitialTasksIfNeeded()
}
