//
//  TaskEntity.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

struct TaskModel: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int?
    
    var description: String {
        "Task for user \(userId ?? 0)"
    }
}
