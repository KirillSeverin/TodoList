//
//  EditTaskViewProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import Foundation

protocol EditTaskViewProtocol: AnyObject {
    func setTask(title: String?, description: String?, date: String?)
    func dismissView()
    func showError(_ message: String)
}
