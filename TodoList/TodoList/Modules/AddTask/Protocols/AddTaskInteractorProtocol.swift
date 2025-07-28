//
//  AddTaskInteractorProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

protocol AddTaskInteractorProtocol: AnyObject {
    func saveTask(title: String, description: String)
}
