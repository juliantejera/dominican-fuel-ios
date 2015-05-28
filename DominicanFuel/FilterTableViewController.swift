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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
