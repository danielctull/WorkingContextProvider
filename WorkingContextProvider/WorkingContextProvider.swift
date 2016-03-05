
import Foundation
import CoreData

@objc public class WorkingContextProvider: NSObject {

	public let mainContext: NSManagedObjectContext
	public let workingContext: NSManagedObjectContext

	public init(managedObjectContext: NSManagedObjectContext) {
		mainContext = managedObjectContext
		workingContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
		workingContext.persistentStoreCoordinator = mainContext.persistentStoreCoordinator
		super.init()

		let notificationCenter = NSNotificationCenter.defaultCenter()
		notificationCenter.addObserver(self, selector: "importContextDidSaveNotification:", name: NSManagedObjectContextDidSaveNotification, object: workingContext)
	}

	@objc private func importContextDidSaveNotification(notification: NSNotification) {
		mainContext.mergeChangesFromContextDidSaveNotification(notification)
	}
}
