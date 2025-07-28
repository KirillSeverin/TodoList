//
//  TaskListPresenter.swift
//  TodoList
//
//  Created by Kirill Severin on 28.07.25.
//

import CoreData
import UIKit

final class TaskListPresenter: NSObject, TaskListPresenterProtocol {
    
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    private var fetchedResultsController: NSFetchedResultsController<TaskEntity>!
    
    override init() {
        super.init()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }
    
    func viewDidLoad() {
        interactor?.fetchInitialTasksIfNeeded()
    }
    
    func didLoadInitialTasks() {
        try? fetchedResultsController.performFetch()
        view?.reloadTasks()
    }
    
    func didTapAddTask(from view: UIViewController) {
        router?.navigateToAddTask(from: view)
    }
    
    func numberOfTasks() -> Int {
        fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func task(at indexPath: IndexPath) -> TaskEntity {
        fetchedResultsController.object(at: indexPath)
    }
}

extension TaskListPresenter: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        view?.reloadTasks()
    }
}
