//
//  TaskListPresenter.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import CoreData
import UIKit

final class TaskListPresenter: TaskListPresenterProtocol {
    
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    weak var router: TaskListRouterProtocol?
    private var fetchedResultsController: NSFetchedResultsController<TaskEntity>!
    
    init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        try? fetchedResultsController.performFetch()
    }
    
    func viewDidLoaded() {
        interactor?.fetchInitialTasksIfNeeded()
    }
    
    func didLoadInitialTasks() {
        try? fetchedResultsController.performFetch()
        view?.reloadTasks()
    }
    
    func numberOfTasks() -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func task(at indexPath: IndexPath) -> TaskEntity {
        fetchedResultsController.object(at: indexPath)
    }
}
