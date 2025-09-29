//
//  TaskListRouter.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

final class TaskListRouter: TaskListRouterProtocol {
    
    static func assembleModule() -> UIViewController {
        let view = TaskListViewController()
        let presenter = TaskListPresenter()
        let router = TaskListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return view
    }
    
    func navigateToAddTask(from view: UIViewController) {
        let addTaskViewController = AddTaskRouter.assembleModule()
        view.present(UINavigationController(rootViewController: addTaskViewController), animated: true)
    }
    
    func navigateToEditTask(from view: UIViewController, task: TaskEntity) {
        let editVC = EditTaskRouter.assembleModule(with: task)
        view.navigationController?.pushViewController(editVC, animated: true)
    }
}
