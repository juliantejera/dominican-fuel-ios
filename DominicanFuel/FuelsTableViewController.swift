//
//  FuelsTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelsTableViewController: CoreDataTableViewController, UIPopoverPresentationControllerDelegate, ManagedDocumentCoordinatorDelegate {
    
    var document: UIManagedDocument?
    
    var selectedDate: NSDate = NSDate.lastSaturday() {
        didSet {
            reloadFetchedResultsController()
        }
    }
    
    lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
    }()
    
    lazy var numberFormatter: NSNumberFormatter = {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentCoordinator = DominicanFuelManagedDocumentCoordinator()
        documentCoordinator.delegate = self
        documentCoordinator.setupDocument()
    }
    
    
    func reloadFetchedResultsController() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            var selectedFuelFiltersTypes = selectedFuelFilters().map({ $0.type })
            if selectedFuelFiltersTypes.count > 0 {
                request.predicate = NSPredicate(format: "(publishedAt >= %@ AND publishedAt <= %@) AND type IN %@", selectedDate.beginningOfDay, selectedDate.endOfDay, selectedFuelFiltersTypes)
            }
            
            var publishedAtDescending = NSSortDescriptor(key: "publishedAt", ascending: false, selector: "compare:")
            var typeAscending = NSSortDescriptor(key: "type", ascending: true, selector: "localizedStandardCompare:")
            request.sortDescriptors = [publishedAtDescending, typeAscending]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "publishedAt", cacheName: nil)
        }
    }
    
    func selectedFuelFilters() -> [FuelFilter] {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: FuelFilter.entityName())
            request.predicate = NSPredicate(format: "isSelected == 1", argumentArray: nil)
            var error: NSError? = nil
            
            if let fuelFilters = managedObjectContext.executeFetchRequest(request, error: &error) as? [FuelFilter] {
                return fuelFilters
            } else {
                println("Error: \(error)")
            }
        }
        
        return [FuelFilter]()
    }
 
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        reloadFetchedResultsController()
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
                    let sixDaysInSeconds: NSTimeInterval = 60*60*24*6
                    var effectiveUntil = NSDate(timeInterval: sixDaysInSeconds, sinceDate: date)
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
            var deltaIcon = ""
            if fuel.delta > 0 {
                deltaIcon = "😱‼️"
            } else if fuel.delta < 0 {
                deltaIcon = "😁"
            } else {
                deltaIcon = "✅"
            }
            
            
            cell.textLabel?.text = "\(deltaIcon) \(fuel.type)"
            cell.detailTextLabel?.text = numberFormatter.stringFromNumber(fuel.price)
        }
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "FilterSegue" {
            if let controller = segue.destinationViewController as? FilterTableViewController {
                controller.document = self.document
                controller.popoverPresentationController?.delegate = self
            }
        }
    }

    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        UIView.transitionWithView(self.tableView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.reloadFetchedResultsController()
        }) { (success) -> Void in
            // TODO
        }
    }
}
