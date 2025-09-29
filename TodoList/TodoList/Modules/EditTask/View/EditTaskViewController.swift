//
//  EditTaskViewController.swift
//  TodoList
//
//  Created by Kirill Severin on 29.07.25.
//

import UIKit

final class EditTaskViewController: UIViewController, EditTaskViewProtocol {
    
    var presenter: EditTaskPresenterProtocol!

    private let titleField = UITextField()
    private let descField = UITextField()
    private let dateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
        setupSaveButton()
        presenter.viewDidLoad()
    }
    
    private func setupSaveButton() {
        let addButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveTapped))
        addButton.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        titleField.placeholder = "Заголовок"
        titleField.font = .preferredFont(forTextStyle: .extraLargeTitle)
        descField.placeholder = "Описание"
        
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .secondaryLabel

        [titleField, descField, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleField.trailingAnchor),
            
            descField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            descField.leadingAnchor.constraint(equalTo: titleField.leadingAnchor),
            descField.trailingAnchor.constraint(equalTo: titleField.trailingAnchor)
        ])
    }

    @objc private func saveTapped() {
        presenter.didTapSave(title: titleField.text, description: descField.text)
    }

    func setTask(title: String?, description: String?, date: String?) {
        titleField.text = title
        descField.text = description
        dateLabel.text = date
    }

    func dismissView() {
        navigationController?.popViewController(animated: true)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
