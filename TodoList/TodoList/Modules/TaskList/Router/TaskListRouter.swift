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
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        return view
    }
}
