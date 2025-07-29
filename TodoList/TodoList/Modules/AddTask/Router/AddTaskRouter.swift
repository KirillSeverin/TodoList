//
//  AddTaskRouter.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

final class AddTaskRouter: AddTaskRouterProtocol {
    static func assembleModule(with task: TaskEntity? = nil) -> UIViewController {
        let view = AddTaskViewController()
        let presenter = AddTaskPresenter()
        let interactor = AddTaskInteractor()
        let router = AddTaskRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        if let task = task {
            presenter.editingTask = task
        }
        
        return view
    }
}
