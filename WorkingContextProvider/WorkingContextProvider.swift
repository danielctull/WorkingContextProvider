
import Foundation
import CoreData

@objc class WorkingContextProvider: NSObject {

	let mainContext: NSManagedObjectContext
	let workingContext: NSManagedObjectContext

	init(managedObjectContext: NSManagedObjectContext) {
		mainContext = managedObjectContext
		workingContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
		workingContext.persistentStoreCoordinator = mainContext.persistentStoreCoordinator
		super.init()

		let notificationCenter = NSNotificationCenter.defaultCenter()
		notificationCenter.addObserver(self, selector: "importContextDidSaveNotification:", name: NSManagedObjectContextDidSaveNotification, object: workingContext)
	}

	func importContextDidSaveNotification(notification: NSNotification) {
		mainContext.mergeChangesFromContextDidSaveNotification(notification)
	}
}
