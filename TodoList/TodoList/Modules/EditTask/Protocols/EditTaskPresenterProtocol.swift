//
//  EditTaskPresenterProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import Foundation

protocol EditTaskPresenterProtocol: AnyObject {
    var task: TaskEntity! { get set }
    func viewDidLoad()
    func didTapSave(title: String?, description: String?)
}
