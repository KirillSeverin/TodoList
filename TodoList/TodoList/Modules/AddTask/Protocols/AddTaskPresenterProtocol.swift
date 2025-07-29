//
//  AddTaskPresenterProtocol.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import Foundation

protocol AddTaskPresenterProtocol: AnyObject {
    func didTapSave(title: String?, description: String?)
    func didSaveTask()
}
