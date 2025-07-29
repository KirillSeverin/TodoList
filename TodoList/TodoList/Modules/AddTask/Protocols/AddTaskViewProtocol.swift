//
//  AddTaskViewProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

protocol AddTaskViewProtocol: AnyObject {
    func showError(_ message: String)
    func dismissView()
}
