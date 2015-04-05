//
//  FuelsTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelsTableViewController: CoreDataTableViewController, ManagedDocumentCoordinatorDelegate, UIPopoverPresentationControllerDelegate {
    
    let dateFormatter = NSDateFormatter()
    let numberFormatter = NSNumberFormatter()
    var document: UIManagedDocument?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        let documentCoordinator = DominicanFuelManagedDocumentCoordinator()
        documentCoordinator.delegate = self
        documentCoordinator.setupDocument()
    }
    
    
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        
        if let managedObjectContext = document.managedObjectContext {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            var publishedAtDescending = NSSortDescriptor(key: "publishedAt", ascending: false, selector: "compare:")
            var typeAscending = NSSortDescriptor(key: "type", ascending: true, selector: "localizedStandardCompare:")
            request.sortDescriptors = [publishedAtDescending, typeAscending]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "publishedAt", cacheName: nil)
        }
    }
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        // Handle error
        println("Error: \(error)")
    }
    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionInfo = self.fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo {
            if let fuel = sectionInfo.objects.first as? Fuel {
                if let date = fuel.publishedAt {
                    var effectiveUntil = NSDate(timeInterval: 60*60*24*6, sinceDate: date)
                    return "\(dateFormatter.stringFromDate(date)) - \(dateFormatter.stringFromDate(effectiveUntil))"
                }
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FuelCell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        
        if let fuel = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Fuel {
            cell.textLabel?.text = fuel.type
            cell.detailTextLabel?.text = numberFormatter.stringFromNumber(fuel.price)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "FilterSegue" {
            if let controller = segue.destinationViewController as? UIViewController {
                controller.popoverPresentationController?.delegate = self
            }
        }
    }

    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
