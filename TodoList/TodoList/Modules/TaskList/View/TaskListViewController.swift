//
//  TaskListViewController.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit

final class TaskListViewController: UIViewController, TaskListViewProtocol {
    
    var presenter: TaskListPresenterProtocol!
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoaded()
        setupUI()
    }
    
    private func setupUI() {
        title = "Tasks"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func reloadTasks() {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfTasks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = presenter.task(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = task.title
        config.secondaryText = task.isCompleted ? "✔ Done" : "⏳ Pending"
        cell.contentConfiguration = config
        return cell
    }
}
