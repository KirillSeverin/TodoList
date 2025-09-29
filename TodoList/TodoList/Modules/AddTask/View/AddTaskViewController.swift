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
    private let saveButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupForm()
        setupSaveButton()
    }
    
    private func setupSaveButton() {
        saveButton.setTitle( "Сохранить", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.backgroundColor = .systemOrange
        saveButton.setTitleColor(.systemBackground, for: .normal)
        saveButton.layer.cornerRadius = 25
        saveButton.titleLabel?.textAlignment = .center
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    private func setupForm() {
        title = "Новая задача"
        view.backgroundColor = .systemBackground
        titleField.placeholder = "Заголовок"
        descField.placeholder = "Описание"
        
        titleField.translatesAutoresizingMaskIntoConstraints = false
        descField.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleField)
        view.addSubview(descField)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            titleField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            descField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 30),
            descField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            descField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)])
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
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
