//
//  FuelsTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import GoogleMobileAds

class FuelsTableViewController: CoreDataTableViewController, UIPopoverPresentationControllerDelegate, GADBannerViewDelegate {
    
    
    @IBOutlet weak var googleAdView: GADBannerView? {
        didSet {
            googleAdView?.delegate = self
            googleAdView?.rootViewController = self
            googleAdView?.adUnitID = "ca-app-pub-3743373903826064/5760698435"
        }
    }
    
    var document: UIManagedDocument? {
        didSet {
            reloadFetchedResultsController()
            updateFuels()
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
        
        let request = GADRequest()
        request.testDevices = ["97cae6e4f669f3e8527d82ad261cc092", kGADSimulatorID]
        googleAdView?.loadRequest(request)
    }

    func updateFuels() {
        if let managedObjectContext = document?.managedObjectContext {
            
            var request = NSFetchRequest(entityName: Fuel.entityName())
            var error: NSError? = nil
            request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
            request.fetchLimit = 1
            
            if let result = managedObjectContext.executeFetchRequest(request, error: &error)?.first as? Fuel {
                if let date = result.publishedAt?.description {
                    let parameters = ["published_at": date]
                    FuelRepository().findAll(parameters) { (response: MultipleItemsNetworkResponse) -> Void in
                        switch response {
                        case .Failure(let error):
                            println("Error: \(error)")
                        case .Success(let items):
                            for dictionary in items {
                                if let fuel = NSEntityDescription.insertNewObjectForEntityForName(Fuel.entityName(), inManagedObjectContext: managedObjectContext) as? Fuel {
                                    fuel.populateWithDictionary(dictionary)
                                }
                            }
                        }
                    }
                }
                
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    func reloadFetchedResultsController() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            var selectedFuelFiltersTypes = FuelFilter.selectedFuelFilters(managedObjectContext).map({ $0.type })
            if selectedFuelFiltersTypes.count > 0 {
                request.predicate = NSPredicate(format: "type IN %@", selectedFuelFiltersTypes)
            }
            
            var publishedAtDescending = NSSortDescriptor(key: "publishedAt", ascending: false, selector: "compare:")
            var typeAscending = NSSortDescriptor(key: "type", ascending: true, selector: "localizedStandardCompare:")
            request.sortDescriptors = [publishedAtDescending, typeAscending]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "publishedAt", cacheName: nil)
        }
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
    
//    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
//        
//        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Compartir") { (action, indexPath) -> Void in
//            if let fuel = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Fuel {
//                var viewModel = self.fuelViewModelFactory.mapToViewModel(fuel)
//                let textToShare = viewModel.description
//                let controller = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
//                controller.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
//                self.presentViewController(controller, animated: true, completion: nil)
//            }
//        }
//        
//        shareAction.backgroundEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        
//        return [shareAction]
//    }
//    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
    
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
    
    
    // MARK: - Google Ad Banner View Delegate
    func adViewDidReceiveAd(view: GADBannerView!) {
        
        UIView.transitionWithView(self.tableView.tableHeaderView!, duration: 0.2, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            self.tableView.tableHeaderView = view

        }, completion: nil)
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        println(error.localizedDescription)
        
        UIView.transitionWithView(self.tableView.tableHeaderView!, duration: 0.2, options: UIViewAnimationOptions.TransitionFlipFromRight, animations: { () -> Void in
            self.tableView.tableHeaderView = nil
            
        }, completion: nil)
    }
    
    func adViewWillPresentScreen(adView: GADBannerView!) {
        
    }
    
    func adViewWillDismissScreen(adView: GADBannerView!) {
        
    }
    
    func adViewDidDismissScreen(adView: GADBannerView!) {
        
    }
    
    func adViewWillLeaveApplication(adView: GADBannerView!) {
        
    }
}
