//
//  FuelsTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/21/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import iAd

class FuelsTableViewController: CoreDataTableViewController, UIPopoverPresentationControllerDelegate, ManagedDocumentCoordinatorDelegate, ADBannerViewDelegate {
    
    //@IBOutlet weak var gadBannerView: GADBannerView!
    
//    var googleAdView: GADBannerView? {
//        didSet {
//            googleAdView?.delegate = self
//            googleAdView?.rootViewController = self
//            googleAdView?.adUnitID = "REPLACE_ID"
//            var request = GADRequest()
//            request.testDevices = ["DEVICE IDENTIFIER"]
//            googleAdView?.loadRequest(request)
//        }
//    }
    
    @IBOutlet weak var iAdView: ADBannerView! {
        didSet {
            iAdView?.delegate = self
        }
    }
    
    var document: UIManagedDocument?
    
    var selectedDate: NSDate = NSDate.lastSaturday() {
        didSet {
            reloadFetchedResultsController()
        }
    }

    lazy var factory = FuelViewModelFactory()
    lazy var upArrow = UIImage(named: "up_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var downArrow = UIImage(named: "down_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var equalSign = UIImage(named: "equal_sign")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var upArrowTintColor = UIColor.redColor()
    lazy var downArrowTintColor = UIColor.greenColor()
    lazy var equalSignTintColor = UIColor.orangeColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentCoordinator = DominicanFuelManagedDocumentCoordinator()
        documentCoordinator.delegate = self
        documentCoordinator.setupDocument()
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
        // Handle error
        println("Error: \(error)")
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionInfo = self.fetchedResultsController.sections?[section] as? NSFetchedResultsSectionInfo {
            if let fuel = sectionInfo.objects.first as? Fuel {
                return factory.mapToViewModel(fuel).timespan
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FuelCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        
        if let fuel = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Fuel {
            let fuelViewModel = factory.mapToViewModel(fuel)
            cell.textLabel?.text = fuelViewModel.type
            cell.detailTextLabel?.text = fuelViewModel.price
            
            if let imageView = cell.imageView {
                updateImageView(imageView, delta: fuel.delta)
            }
        }
        
        return cell
    }
    
    func updateImageView(imageView: UIImageView, delta: Double) {
        if delta > 0 {
            imageView.tintColor = upArrowTintColor
            imageView.image = upArrow
        } else if delta < 0 {
            imageView.tintColor = downArrowTintColor
            imageView.image = downArrow
        } else {
            imageView.tintColor = equalSignTintColor
            imageView.image = equalSign
        }
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
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    if let fuel = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Fuel {
                        controller.fuel = fuel
                    }
                }
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
    
//    // MARK: - Google Ad Banner View Delegate
//    func adViewDidReceiveAd(view: GADBannerView!) {
//        
//    }
//
//    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
//        
//    }
//    
//    func adViewWillPresentScreen(adView: GADBannerView!) {
//        
//    }
//    
//    func adViewWillDismissScreen(adView: GADBannerView!) {
//        
//    }
//    
//    func adViewDidDismissScreen(adView: GADBannerView!) {
//        
//    }
//    
//    func adViewWillLeaveApplication(adView: GADBannerView!) {
//        
//    }
//    
    
    // MARK: - iAd Delegate
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        layoutAd(banner, animated: true)

    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        layoutAd(banner, animated: true)
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }
    
    func layoutAd(adView: UIView, animated: Bool) {
        var contentFrame = self.tableView.bounds
        var bannerFrame = adView.frame

        if (self.iAdView!.bannerLoaded) {
            contentFrame.size.height -= adView.frame.height
        }
        
        bannerFrame.origin.y = contentFrame.height
        
        UIView.animateWithDuration(animated ? 0.25 : 0) {
            self.tableView.frame = contentFrame
            self.tableView.layoutIfNeeded()
            adView.frame = bannerFrame
        }
    }
}
