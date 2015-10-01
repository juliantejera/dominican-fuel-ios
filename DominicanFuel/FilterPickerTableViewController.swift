//
//  FilterPickerTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 9/29/15.
//  Copyright © 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FilterPickerTableViewController: CoreDataTableViewController {
    var document: UIManagedDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: FuelFilter.entityName())
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: "compare:")]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterPickerCell", forIndexPath: indexPath)
        
        if let filter = self.fetchedResultsController.objectAtIndexPath(indexPath) as? FuelFilter {
            cell.textLabel?.text = filter.type
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "ChartsSegue" {
            if let chartViewController = segue.destinationViewController.contentViewController as? ChartViewController, let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPathForCell(cell), let filter = self.fetchedResultsController.objectAtIndexPath(indexPath) as? FuelFilter  {
                chartViewController.document = self.document
                chartViewController.filter = filter
            }
        }
    }


}
