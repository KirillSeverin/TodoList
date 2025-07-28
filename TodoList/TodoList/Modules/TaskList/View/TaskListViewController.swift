//
//  TaskListViewController.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

final class TaskListViewController: UIViewController, TaskListViewProtocol {
    
    var presenter: TaskListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        presenter.viewDidLoaded()
    }
    
    func reloadTasks() {
        
    }
    
    func showError(_ message: String) {
        
    }

}

