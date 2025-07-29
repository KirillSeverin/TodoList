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
    private let searchController = UISearchController(searchResultsController: nil)
    private let speechManager = SpeechRecognitionManager()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Задачи"
        label.font = .preferredFont(forTextStyle: .extraLargeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButtonItem: UIBarButtonItem = {
        let backItem = UIBarButtonItem()
        backItem.title = "Назад"
        backItem.tintColor = .systemOrange
        return backItem
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupUI()
        setupAddButton()
        setupSearch()
    }
    
    private func setupAddButton() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTaskTapped))
        addButton.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupSearch() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(
            UIImage(systemName: "mic"),
            for: .bookmark,
            state: .normal
        )
        searchController.searchBar.delegate = self
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Speach authorized")
            default:
                print("Speach not available")
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem = backButtonItem
        let leftItem = UIBarButtonItem(customView: titleContainerView)
        navigationItem.leftBarButtonItem = leftItem
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        titleContainerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func addTaskTapped() {
        presenter.didTapAddTask(from: self)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.toggleTaskStatus(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
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
