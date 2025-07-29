//
//  EditTaskRouterProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import UIKit

protocol EditTaskRouterProtocol: AnyObject {
    static func assembleModule(with task: TaskEntity) -> UIViewController
}
