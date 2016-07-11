//
//  ViewController.swift
//  HitList
//
//  Created by Catalin David on 29/06/16.
//  Copyright © 2016 Catalin David. All rights reserved.
//

import UIKit
import CoreData

//MARK: - Class TableViewController Implementation

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
	
	@IBOutlet weak var editButton: UIBarButtonItem!
	
	var appDelegate: AppDelegate?
	var fetchedResultController: NSFetchedResultsController?
	var edit: Bool = true
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		editButton.title = "Edit"
		title = "Reminder"
		
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		self.navigationController?.navigationBar.barTintColor = UIColor .brownColor()
		self.navigationController?.navigationBar.tintColor = UIColor .whiteColor()
		
		do {
			self.fetchedController()
			try self.fetchedResultController?.performFetch()
			
		} catch let error as NSError {
			print("Could not performFetch \(error), \(error.userInfo)")
		}
		
	}
	
	func fetchedController() -> NSFetchedResultsController? {
		
		if self.fetchedResultController == nil {
			guard let appDelegate = self.appDelegate else {
				return nil
			}
			
			let managedContext = appDelegate.managedObjectContext
			let fetchRequest = NSFetchRequest(entityName: "Reminder")
			let sortDescriptor = NSSortDescriptor(key: "taskName", ascending: true)
			
			fetchRequest.sortDescriptors = [sortDescriptor]
			self.fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
			                                                          managedObjectContext: managedContext,
			                                                          sectionNameKeyPath: nil,
			                                                          cacheName: nil)
			self.fetchedResultController?.delegate = self
		}
		
		return self.fetchedResultController!
	}
	
}//end class

//MARK: - EXTENSIONS

//MARK: - Specific action buttons
extension TableViewController {
	
	@IBAction func editTapped(sender: AnyObject) {
		
		if edit {
			editButton.title = "Back"
			tableView.editing = edit
			edit = false
		} else {
			editButton.title = "Edit"
			tableView.editing = edit
			edit = true
		}
		
	}
	
	@IBAction func addTask(sender: AnyObject) {
		
		let alert = UIAlertController(title: "New Reminder",
		                              message: "Add a new task with format \n \t'Name - hh:mm'",
		                              preferredStyle: .Alert)
		
		let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {
			[weak self] (action:UIAlertAction) -> Void in
			
			if let textField = alert.textFields?.first {
				if let result = textField.text?.componentsSeparatedByString("-") {
					self?.saveTask(result[0], taskHoure: result[1])
				}
			}
			
			})
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler:
			{ (action: UIAlertAction) -> Void in
		})
		
		alert.addTextFieldWithConfigurationHandler {
			(textField: UITextField) -> Void in
		}
		
		alert.addAction(saveAction)
		alert.addAction(cancelAction)
		
		presentViewController(alert, animated: true, completion: nil)
		
	}
	
	//MARK: - Helper func for addTask
	
	func saveTask(taskName: String, taskHoure: String) {
		
		if let appDelegate = self.appDelegate {
			let managedContext = appDelegate.managedObjectContext
			
			if let entity = NSEntityDescription.entityForName("Reminder", inManagedObjectContext: managedContext) {
				let reminder = NSManagedObject(entity: entity, insertIntoManagedObjectContext: managedContext) as? Reminder
				reminder?.taskName = taskName
				reminder?.taskHoure = taskHoure
				
				do {
					try managedContext.save()
					
				} catch let error as NSError {
					print("Could not save \(error), \(error.userInfo)")
				}
			}
		}
	}
	
}//end extension Action Buttons

//MARK: - NSFetchResultControllerDelegate

extension TableViewController {
	
	func controllerWillChangeContent(controller: NSFetchedResultsController) {
		tableView.beginUpdates()
		
	}
	
	func controller(controller: NSFetchedResultsController,
	                didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
					atIndex sectionIndex: Int,
					forChangeType type: NSFetchedResultsChangeType) {
		
		switch type {
			
		case NSFetchedResultsChangeType.Insert:
			tableView.insertSections(NSIndexSet(index: sectionIndex),
			                         withRowAnimation: UITableViewRowAnimation.Fade)
		case NSFetchedResultsChangeType.Delete:
			tableView.deleteSections(NSIndexSet(index: sectionIndex),
			                         withRowAnimation: UITableViewRowAnimation.Fade)
		default:
			break
		}
		
	}
	
	func controller(controller: NSFetchedResultsController,
	                didChangeObject anObject: AnyObject,
					atIndexPath indexPath: NSIndexPath?,
					forChangeType type: NSFetchedResultsChangeType,
					newIndexPath: NSIndexPath?) {
		
		switch type {
			
		case NSFetchedResultsChangeType.Insert:
			if let newIndexPath = newIndexPath {
				tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Fade)
			}
		case NSFetchedResultsChangeType.Delete:
			if let indexPath = indexPath {
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
			}
		case NSFetchedResultsChangeType.Update:
			if let indexPath = indexPath {
				guard let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell? else {
					return
				}
				if let item = self.fetchedResultController?.objectAtIndexPath(indexPath) as? Reminder {
					cell.textLabel?.text = item.taskName
					cell.detailTextLabel?.text = item.taskHoure
				}
			}
		case NSFetchedResultsChangeType.Move:
			if let indexPath = indexPath, let newIndexPath = newIndexPath {
				tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
				tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation:UITableViewRowAnimation.Fade)
			}
		}
		
	}
	
	func controllerDidChangeContent(controller: NSFetchedResultsController) {
		tableView.endUpdates()
	}
	
}//end extension NSFetchResultsControllerDelegate methods

//MARK: - TableView DataSource and Delegate

extension TableViewController {
	
	//MARK: - DataSource
	
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.fetchedResultController?.sections?.count ?? 1
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let numberOfObjects = self.fetchedResultController?.sections?[section].numberOfObjects else {
			return 0
		}
		return numberOfObjects
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCellWithIdentifier("Cell") else {
			return UITableViewCell()
		}
		
		if let reminder = self.fetchedResultController?.objectAtIndexPath(indexPath) as? Reminder {
			cell.textLabel?.text = reminder.taskName
			cell.detailTextLabel?.text = reminder.taskHoure
		}
		
		return cell
		
	}
	
	override func tableView(tableView: UITableView,
				  moveRowAtIndexPath sourceIndexPath: NSIndexPath,
				  toIndexPath destinationIndexPath: NSIndexPath) {
		
		print("MovedRow from row \(sourceIndexPath.row) to row \(destinationIndexPath.row)")
	}
	
	override func tableView(tableView: UITableView,
				  commitEditingStyle editingStyle: UITableViewCellEditingStyle,
				  forRowAtIndexPath indexPath: NSIndexPath) {
		
		if let appDelegate = self.appDelegate {
			let managedContext = appDelegate.managedObjectContext
			
			if editingStyle == UITableViewCellEditingStyle.Delete  {
				
				do {
					guard let objectToDelete = self.fetchedResultController?.objectAtIndexPath(indexPath) as? Reminder else {
						return
					}
					managedContext.deleteObject(objectToDelete)
					try managedContext.save()
					
				} catch let error as NSError {
					print("Delete failed \(error), \(error.userInfo)")
				}
			}
			
		} else {
			print("AppDelegate is nil")
		}
		
	}
	
	//MARK: - Delegate
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		let alert = UIAlertController(title: "Edit Reminder",
		                              message: "Edit with format \n \t'Name - hh:mm'",
		                              preferredStyle: .Alert)
		
		let updateAction = UIAlertAction(title: "Update", style: .Default, handler: {
			[weak self] (action:UIAlertAction) -> Void in
			
			if let textField = alert.textFields?.first {
				
				if let result = textField.text?.componentsSeparatedByString("-") {
				
					if let appDelegate = self?.appDelegate {
						let managedContext = appDelegate.managedObjectContext
						
						if let objectToUpdate = self?.fetchedResultController?.objectAtIndexPath(indexPath) as? Reminder {
							objectToUpdate.taskName = result[0]
							objectToUpdate.taskHoure = result[1]
							do {
								try managedContext.save()
								
							} catch let error as NSError {
								print("Error at saving \(error), \(error.userInfo)")
							}
						}
					}
				}
			}
			
			tableView.deselectRowAtIndexPath(indexPath, animated: false)
			})
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: {
			(action: UIAlertAction) -> Void in
			  tableView.deselectRowAtIndexPath(indexPath, animated: false)
		})
		
		alert.addTextFieldWithConfigurationHandler {
			(textField: UITextField) -> Void in
		}
		
		alert.addAction(updateAction)
		alert.addAction(cancelAction)
		
		presentViewController(alert, animated: true, completion: nil)
	}
	
}//end extension DataSource - Delegate
