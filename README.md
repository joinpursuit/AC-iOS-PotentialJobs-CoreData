## Core Data

## Key Interview Questions  
What is Core Data?   
What is a Managed Object Context?  

#### Core Data  
Core Data is a framework that you use to manage the model layer objects in your application. It provides generalized and automated solutions to common tasks associated with object life cycle and object graph management, including persistence.

#### NSManagedObjectContext**
The managed object context (NSManagedObjectContext) is the object that your application will interact with the most, and therefore it is the one that is exposed to the rest of your application. Think of the managed object context as an intelligent scratch pad. When you fetch objects from a persistent store, you bring temporary copies onto the scratch pad where they form an object graph (or a collection of object graphs). You can then modify those objects however you like. Unless you actually save those changes, however, the persistent store remains unaltered.

All managed objects must be registered with a managed object context. You use the context to add objects to the object graph and remove objects from the object graph. The context tracks the changes you make, both to individual objects’ attributes and to the relationships between objects. By tracking changes, the context is able to provide undo and redo support for you. It also ensures that if you change relationships between objects, the integrity of the object graph is maintained.

If you choose to save the changes you have made, the context ensures that your objects are in a valid state. If they are, the changes are written to the persistent store (or stores), new records are added for objects you created, and records are removed for objects you deleted.

Without Core Data, you have to write methods to support archiving and unarchiving of data, to keep track of model objects, and to interact with an undo manager to support undo. In the Core Data framework, most of this functionality is provided for you automatically, primarily through the managed object context.

#### NSPersistentContainer
Starting in iOS 10 and macOS 10.12, the NSPersistentContainer handles the creation of the Core Data stack and offers access to the NSManagedObjectContext as well as a number of convenience methods. Prior to iOS 10 and macOS 10.12, the creation of the Core Data stack was more involved.

#### NSManagedObjectModel
The NSManagedObjectModel instance describes the data that is going to be accessed by the Core Data stack. During the creation of the Core Data stack, the NSManagedObjectModel is loaded into memory as the first step in the creation of the stack. The example code above resolves an NSURL from the main application bundle using a known filename (in this example DataModel.momd) for the NSManagedObjectModel. After the NSManagedObjectModel object is initialized, the NSPersistentStoreCoordinator object is constructed.

#### NSPersistentStoreCoordinator
The NSPersistentStoreCoordinator sits in the middle of the Core Data stack. The coordinator is responsible for realizing instances of entities that are defined inside of the model. It creates new instances of the entities in the model, and it retrieves existing instances from a persistent store (NSPersistentStore). The persistent store can be on disk or in memory. Depending on the structure of the application, it is possible, although uncommon, to have more than one persistent store being coordinated by the NSPersistentStoreCoordinator.

Whereas the NSManagedObjectModel defines the structure of the data, the NSPersistentStoreCoordinator realizes objects from the data in the persistent store and passes those objects off to the requesting NSManagedObjectContext. The NSPersistentStoreCoordinator also verifies that the data is in a consistent state that matches the definitions in the NSManagedObjectModel.

The call to add the NSPersistentStore to the NSPersistentStoreCoordinator is performed asynchronously. A few situations can cause this call to block the calling thread (for example, integration with iCloud and Migrations). Therefore, it is better to execute this call asynchronously to avoid blocking the user interface queue.





**Get the Managed Object Context from the App Delegate Core Data Stack**
```swift 
private func getManagedObjectContext() {
    // Get a reference to the App Delegate
    appDelegate = UIApplication.shared.delegate as! AppDelegate

    // Get the managed object context
    managedContext = appDelegate.persistentContainer.viewContext
}

private func fetchJobs() {
    // Create a fetch request
    let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Job")

    // Fetch from managed context
    do {
        jobs = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("fetch jobs error: \(error), \(error.userInfo)")
    }
}
```

**Fetch Managed Objects from Core Data**
```swift 
private func fetchJobs() {
    // Create a fetch request
    let fetchRequest = NSFetchRequest<NSManagedObject>.init(entityName: "Job")

    // Fetch from managed context
    do {
        jobs = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("fetch jobs error: \(error), \(error.userInfo)")
    }
}
```

**Save to the Managed Object Context**
```swift 
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
```

**Delete from the Managed Object Context**
```swift 
private func delete(indexPath: IndexPath) {
    // Remove managed object from core data
    let job = jobs[indexPath.row ]
    managedContext.delete(job)

    // Save the managed object context as to commit the changes
    do {
        try managedContext.save()
        jobs.remove(at: indexPath.row)
    } catch let error as NSError {
        print("delete error: \(error), \(error.userInfo)")
    }
}
```


| Resource | Summary |
|:------|:-------|
| [Unit 5 - Core Data Intro](https://github.com/C4Q/AC-iOS/tree/master/lessons/unit5/Core%20Data%20Introduction) | Unit 5 - Core Data Intro |
| [Apple Documentation - Core Data Programming Guide ](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreData/index.html#//apple_ref/doc/uid/TP40001075-CH2-SW1) | Core Data Programming Guide |

