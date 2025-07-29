//
//  EditTaskRouter.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import UIKit

final class EditTaskRouter: EditTaskRouterProtocol {
    
    static func assembleModule(with task: TaskEntity) -> UIViewController {
        let view = EditTaskViewController()
        let presenter = EditTaskPresenter()
        let interactor = EditTaskInteractor()
        let router = EditTaskRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.task = task
        
        interactor.presenter = presenter
        
        return view
    }
}
