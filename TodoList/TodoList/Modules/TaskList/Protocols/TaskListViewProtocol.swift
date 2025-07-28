//
//  TaskListViewProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

protocol TaskListViewProtocol: AnyObject {
    func reloadTasks()
    func showError(_ message: String)
}
