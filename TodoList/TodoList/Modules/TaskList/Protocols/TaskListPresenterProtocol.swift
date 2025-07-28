//
//  TaskListPresenterProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func didLoadInitialTasks()
}
