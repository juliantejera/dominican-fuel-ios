//
//  FilterTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/30/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import CoreData
class FilterTableViewController: CoreDataTableViewController {

    var document: UIManagedDocument?
    
    let tableViewRowDefaultHeight: CGFloat = 44
    let maxNumberOfRows: CGFloat = 7
    override var preferredContentSize: CGSize {
        get {
            return CGSize(width: super.preferredContentSize.width, height: tableViewRowDefaultHeight * maxNumberOfRows)
        }
        set {
            super.preferredContentSize = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: FuelFilter.entityName())
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: "compare:")]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    // MARK: = Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        toggleAccessoryViewOfCellAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        toggleAccessoryViewOfCellAtIndexPath(indexPath)
    }
    
    func toggleAccessoryViewOfCellAtIndexPath(indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if let filter = self.fetchedResultsController.objectAtIndexPath(indexPath) as? FuelFilter {        filter.isSelected = !filter.isSelected
            cell?.accessoryType = filter.isSelected ? .Checkmark : .None
            
            document?.saveToURL(document!.fileURL, forSaveOperation: UIDocumentSaveOperation.ForOverwriting, completionHandler: nil)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as! UITableViewCell
        
        if let filter = self.fetchedResultsController.objectAtIndexPath(indexPath) as? FuelFilter {
            cell.textLabel?.text = filter.type
            cell.accessoryType = filter.isSelected ? .Checkmark : .None
        }
        
        return cell
    }
}
