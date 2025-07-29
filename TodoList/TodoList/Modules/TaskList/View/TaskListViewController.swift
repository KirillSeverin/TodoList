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
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.configure(with: task)
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil) { _ in
                let edit = UIAction(
                    title: "Редактировать",
                    image: UIImage(systemName: "pencil")) { _ in
                        self.presenter.editTask(at: indexPath, from: self)
                    }
                
                let delete = UIAction(
                    title: "Удалить",
                    image: UIImage(
                        systemName: "trash"),
                    attributes: .destructive) { _ in
                        self.presenter.deleteTask(at: indexPath)
                    }
                
                return UIMenu(title: "", children: [edit, delete])
            }
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
