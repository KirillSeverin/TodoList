//
//  EditTaskInteractorProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import Foundation

protocol EditTaskInteractorProtocol: AnyObject {
    func saveTask(task: TaskEntity, title: String, description: String)
}
