//
//  ViewController.swift
//  PotentialJobs
//
//  Created by Alex Paul on 4/26/18.
//  Copyright © 2018 Alex Paul. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var appDelegate: AppDelegate!
    private var managedContext: NSManagedObjectContext!
    
    private var jobs = [NSManagedObject]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        getManagedObjectContext()
        tableView.dataSource = self
        fetchJobs()
    }
}

// MARK:- Helper Methods
extension ViewController {
    private func configureNavBar() {
        navigationItem.title = "Potential Jobs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJob))
    }
    
    private func getManagedObjectContext() {
        // Get a reference to the App Delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Get the managed object context
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    private func fetchJobs() {
//        // Create a fetch request
//        let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Job")
//
//        // Fetch from managed context
//        do {
//            jobs = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("fetch jobs error: \(error), \(error.userInfo)")
//        }
    }
    
    @objc private func addJob() {
        let alertController = UIAlertController(title: "Enter the Company Name", message: "", preferredStyle: .alert)
        alertController.addTextField { (textfield) in}
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] (action) in
            guard let text = alertController.textFields?.first?.text else { return }
            self?.save(companyName: text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func save(companyName: String) {
        // Get entity
        let entity = NSEntityDescription.entity(forEntityName: "Job", in: managedContext)
        let job = NSManagedObject.init(entity: entity!, insertInto: managedContext)

        // Set attributes for Managed Object
        job.setValue(companyName, forKey: "name")

        // Save the context
        do {
            try managedContext.save()
            jobs.append(job)
        } catch let error as NSError {
            print("managed object error: \(error), \(error.userInfo)")
        }
    }
    
    private func delete(indexPath: IndexPath) {
//        // Remove managed object from core data
//        let job = jobs[indexPath.row ]
//        managedContext.delete(job)
//
//        // Save the managed object context as to commit the changes
//        do {
//            try managedContext.save()
//            jobs.remove(at: indexPath.row)
//        } catch let error as NSError {
//            print("delete error: \(error), \(error.userInfo)")
//        }
    }
}

// MARK:- UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath)
        let job = jobs[indexPath.row]
        cell.textLabel?.text = job.value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        delete(indexPath: indexPath)
    }
}

