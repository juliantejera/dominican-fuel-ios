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
            googleAdView?.adUnitID = Ads.admob.rawValue
        }
    }
    
    var document: UIManagedDocument? {
        didSet {
            reloadFetchedResultsController()
            updateFuels()
        }
    }
    
    override var tableView: UITableView! {
        didSet {
            self.refreshControl = UIRefreshControl()
            self.refreshControl?.addTarget(self, action: #selector(FuelsTableViewController.updateFuels), for: UIControlEvents.valueChanged)
        }
    }
    
    lazy var fuelViewModelFactory = FuelViewModelFactory()
    lazy var fuelTableViewCellFactory = FuelTableViewCellFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        googleAdView?.load(request)
    }

    @objc func updateFuels() {
        guard let context = document?.managedObjectContext else {
            self.refreshControl?.endRefreshing()
            return
        }
        
        let fuelSynchronizer = FuelPersistenceSynchronizer(context: context)
        fuelSynchronizer.synchronize()
        self.refreshControl?.endRefreshing()
    }
    
    
    func reloadFetchedResultsController() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Fuel.entityName())
            let selectedFuelFiltersTypes = FuelFilter.selectedFuelFilters(managedObjectContext).map({ $0.type })
            if selectedFuelFiltersTypes.count > 0 {
                request.predicate = NSPredicate(format: "type IN %@", selectedFuelFiltersTypes)
            }
            
            let publishedAtDescending = NSSortDescriptor(key: "publishedAt", ascending: false, selector: #selector(NSNumber.compare(_:)))
            let typeAscending = NSSortDescriptor(key: "type", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            request.sortDescriptors = [publishedAtDescending, typeAscending]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "publishedAt", cacheName: nil)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sectionInfo = self.fetchedResultsController.sections?[section]  {
            if let fuel = sectionInfo.objects?.first as? Fuel {
                return fuelViewModelFactory.mapToViewModel(fuel).timespan
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FuelCell", for: indexPath) as! FuelTableViewCell

        if let fuel = self.fetchedResultsController.object(at: indexPath) as? Fuel {
            fuelTableViewCellFactory.configureCell(cell, forFuel: fuel)
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .normal, title: "Compartir") { (action, indexPath) -> Void in
            if let fuel = self.fetchedResultsController.object(at: indexPath) as? Fuel {
                let viewModel = self.fuelViewModelFactory.mapToViewModel(fuel)
                let textToShare = viewModel.description
                let controller = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
                controller.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
                self.present(controller, animated: true, completion: nil)
            }
            
        }
        
        shareAction.backgroundEffect = UIBlurEffect(style: .dark)
        
        return [shareAction]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilterSegue" {
            if let controller = segue.destination as? FilterTableViewController {
                controller.document = self.document
                controller.popoverPresentationController?.delegate = self
            }
        } else if segue.identifier == "FuelDetailsSegue" {
            if let controller = segue.destination as? FuelDetailsTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let fuel = self.fetchedResultsController.object(at: indexPath) as? Fuel {
                    controller.fuel = fuel
                }
            }
        }
    }

    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        UIView.transition(with: self.tableView, duration: 0.3, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.reloadFetchedResultsController()
        }) { (success) -> Void in
            // TODO
        }
    }
    
    
    // MARK: - Google Ad Banner View Delegate
    func adViewDidReceiveAd(_ view: GADBannerView) {
        
        UIView.transition(with: self.tableView.tableHeaderView!, duration: 0.2, options: .transitionFlipFromRight, animations: { () -> Void in
            self.tableView.tableHeaderView = view

        }, completion: nil)
    }
    
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error.localizedDescription)
        
        UIView.transition(with: self.tableView.tableHeaderView!, duration: 0.2, options: .transitionFlipFromRight, animations: { () -> Void in
            self.tableView.tableHeaderView = nil
            
        }, completion: nil)
    }
    
    func adViewWillPresentScreen(_ adView: GADBannerView) {
        
    }
    
    func adViewWillDismissScreen(_ adView: GADBannerView) {
        
    }
    
    func adViewDidDismissScreen(_ adView: GADBannerView) {
        
    }
    
    func adViewWillLeaveApplication(_ adView: GADBannerView) {
        
    }
}


extension FuelsTableViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: location),
              let cell = tableView.cellForRow(at: indexPath),
              let fuel = self.fetchedResultsController.object(at: indexPath) as? Fuel else {
            return nil
        }
        
        let controller =         self.storyboard?.instantiateViewController(withIdentifier: "FuelDetailsTableViewController") as? FuelDetailsTableViewController
        controller?.fuel = fuel
        controller?.preferredContentSize = CGSize(width: 0, height: 500)
        previewingContext.sourceRect = cell.frame
        return controller
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
