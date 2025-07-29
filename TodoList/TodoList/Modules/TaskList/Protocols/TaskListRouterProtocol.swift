//
//  TaskListRouterProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    func navigateToAddTask(from view: UIViewController)
    func navigateToEditTask(from view: UIViewController, task: TaskEntity)
}
