//
//  TaskListViewController.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import UIKit
import Speech
import AudioToolbox

final class TaskListViewController: UIViewController, TaskListViewProtocol {
    
    var presenter: TaskListPresenterProtocol!
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let speechManager = SpeechRecognitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        setupAddButton()
        setupSearch()
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Speach authorized")
            default:
                print("Speach not available")
            }
        }
    }
    
    private func setupAddButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskTapped))
    }
    
    @objc private func addTaskTapped() {
        presenter.didTapAddTask(from: self)
    }
    
    private func setupSearch() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(
            UIImage(systemName: "mic"),
            for: .bookmark,
            state: .normal
        )
        searchController.searchBar.delegate = self
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

extension TaskListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.searchTextChanged(searchController.searchBar.text ?? "")
    }
}

extension TaskListViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        speechManager.toggleListening { [weak self] resultText in
            guard let self = self else { return }
            self.searchController.searchBar.text = resultText
            self.presenter.searchTextChanged(resultText)
        }
    }
}
