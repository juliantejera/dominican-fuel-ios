//
//  FuelsTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import iAd

class FuelsTableViewController: CoreDataTableViewController, UIPopoverPresentationControllerDelegate, ManagedDocumentCoordinatorDelegate {

    var document: UIManagedDocument?
    
    var selectedDate: NSDate = NSDate.lastSaturday() {
        didSet {
            reloadFetchedResultsController()
        }
    }

    lazy var fuelViewModelFactory = FuelViewModelFactory()
    lazy var fuelTableViewCellFactory = FuelTableViewCellFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "updateFuels", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let documentCoordinator = DominicanFuelManagedDocumentCoordinator()
        documentCoordinator.delegate = self
        documentCoordinator.setupDocument()
    }
    
    func updateFuels() {
        if let managedObjectContext = document?.managedObjectContext {
            FuelSeeder.updateFuels(FuelRepository(), context: managedObjectContext)
            self.refreshControl?.endRefreshing()
        }
    }
    
    func reloadFetchedResultsController() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            var selectedFuelFiltersTypes = FuelFilter.selectedFuelFilters(managedObjectContext).map({ $0.type })
            if selectedFuelFiltersTypes.count > 0 {
                request.predicate = NSPredicate(format: "(publishedAt >= %@ AND publishedAt < %@) AND type IN %@", selectedDate.beginningOfDay, selectedDate.tomorrow.beginningOfDay, selectedFuelFiltersTypes)
            }
            
            var publishedAtDescending = NSSortDescriptor(key: "publishedAt", ascending: false, selector: "compare:")
            var typeAscending = NSSortDescriptor(key: "type", ascending: true, selector: "localizedStandardCompare:")
            request.sortDescriptors = [publishedAtDescending, typeAscending]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "publishedAt", cacheName: nil)
        }
    }

 
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        reloadFetchedResultsController()
    }
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        println("Error: \(error)")
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionInfo = self.fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo {
            if let fuel = sectionInfo.objects.first as? Fuel {
                return fuelViewModelFactory.mapToViewModel(fuel).timespan
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FuelCell", forIndexPath: indexPath) as! FuelTableViewCell

        if let fuel = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Fuel {
            fuelTableViewCellFactory.configureCell(cell, forFuel: fuel)
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Share") { (action, indexPath) -> Void in
            if let fuel = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Fuel {
                var viewModel = self.fuelViewModelFactory.mapToViewModel(fuel)
                let textToShare = viewModel.description
                let controller = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                controller.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
        
        shareAction.backgroundEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        
        return [shareAction]
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FilterSegue" {
            if let controller = segue.destinationViewController as? FilterTableViewController {
                controller.document = self.document
                controller.popoverPresentationController?.delegate = self
            }
        } else if segue.identifier == "FuelDetailsSegue" {
            if let controller = segue.destinationViewController as? FuelDetailsTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell), let fuel = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Fuel {
                    controller.fuel = fuel
                }
            }
        }
    }

    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        UIView.transitionWithView(self.tableView, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.reloadFetchedResultsController()
        }) { (success) -> Void in
            // TODO
        }
    }
}
