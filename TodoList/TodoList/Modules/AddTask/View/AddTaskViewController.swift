//
//  AddTaskViewController.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

final class AddTaskViewController: UIViewController, AddTaskViewProtocol {
    
    var presenter: AddTaskPresenterProtocol!
    
    private let titleField = UITextField()
    private let descField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Task"
        view.backgroundColor = .systemBackground
        setupForm()
        setupSaveButton()
    }
    
    private func setupSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped))
    }
    
    private func setupForm() {
        titleField.placeholder = "Title"
        descField.placeholder = "Description"
        
        titleField.translatesAutoresizingMaskIntoConstraints = false
        descField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleField)
        view.addSubview(descField)
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            descField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 30),
            descField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            descField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)])
    }
    
    @objc private func saveTapped() {
        presenter.didTapSave(
            title: titleField.text ?? "",
            description: descField.text ?? "")
    }
    
    func dismissView() {
        dismiss(animated: true)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
