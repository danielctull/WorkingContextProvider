
import Foundation
import CoreData

@objc public class WorkingContextProvider: NSObject {

	public let mainContext: NSManagedObjectContext
	public let workingContext: NSManagedObjectContext

	public init(managedObjectContext: NSManagedObjectContext) {
		mainContext = managedObjectContext
		workingContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		workingContext.persistentStoreCoordinator = mainContext.persistentStoreCoordinator
		super.init()

		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(WorkingContextProvider.importContextDidSaveNotification(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: workingContext)
	}

	@objc private func importContextDidSaveNotification(_ notification: Notification) {
		mainContext.mergeChanges(fromContextDidSave: notification)
	}
}
