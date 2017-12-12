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
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: FuelFilter.entityName())
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: #selector(NSNumber.compare(_:)))]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    // MARK: = Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toggleAccessoryViewOfCellAtIndexPath(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        toggleAccessoryViewOfCellAtIndexPath(indexPath)
    }
    
    func toggleAccessoryViewOfCellAtIndexPath(_ indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let filter = self.fetchedResultsController.object(at: indexPath) as? FuelFilter {
            filter.isSelected = !filter.isSelected
            cell?.accessoryType = filter.isSelected ? .checkmark : .none
            
            document?.save(to: document!.fileURL, for: UIDocumentSaveOperation.forOverwriting, completionHandler: nil)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) 
        
        if let filter = self.fetchedResultsController.object(at: indexPath) as? FuelFilter {
            cell.textLabel?.text = filter.type
            cell.accessoryType = filter.isSelected ? .checkmark : .none
        }
        
        return cell
    }
}
