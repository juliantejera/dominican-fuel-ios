//
//  FuelDetailsTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/17/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import QuartzCore
import iAd

class FuelDetailsTableViewController: UITableViewController, ADBannerViewDelegate {

    @IBOutlet weak var tableViewHeaderImageView: FuelDetailsTableViewHeaderImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var timespanLabel: UILabel!
    @IBOutlet weak var historyOneMonthAgoLabel: UILabel!
    @IBOutlet weak var historyThreeMonthsAgoLabel: UILabel!
    @IBOutlet weak var historySixMonthsAgoLabel: UILabel!
    @IBOutlet weak var historyOneYearAgoLabel: UILabel!

    @IBOutlet weak var iAdView: ADBannerView! {
        didSet {
            iAdView?.delegate = self
        }
    }
    
    weak var fuel: Fuel? {
        didSet {
            if let fuel = self.fuel {
                self.fuelViewModel = viewModelFactory.mapToViewModel(fuel)
            } else {
                self.fuelViewModel = nil
            }
        }
    }
    
    var fuelViewModel: FuelViewModel?

    lazy var viewModelFactory = FuelViewModelFactory()
    lazy var cellFactory = FuelTableViewCellFactory()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableViewHeaderImageView?.layer.masksToBounds = true
        self.tableViewHeaderImageView?.layer.cornerRadius = tableViewHeaderImageView.frame.height / 2.0
        self.tableViewHeaderImageView?.layer.borderWidth = 4.0
    }
    
    
    @IBAction func share(sender: UIBarButtonItem) {
        if let fuelViewModel = self.fuelViewModel {
            let textToShare = fuelViewModel.description
            let controller = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            controller.popoverPresentationController?.barButtonItem = sender
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func updateUI() {
        self.title = fuelViewModel?.type
        self.priceLabel?.text = fuelViewModel?.price
        self.deltaLabel.text = fuelViewModel?.delta
        self.timespanLabel.text = fuelViewModel?.timespan
        
        if let fuel = self.fuel {            
            self.tableViewHeaderImageView.update(fuel.delta)
        }
        
        // Historic labels
        // TODO: Move all this logic to a new class and load this dynamically
        var today = NSDate()
        if let oneMonthAgo = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -1, toDate: today, options: nil) {
            if let historicFuel = self.fuel?.historicFuelAtDate(NSDate.lastSaturday(date: oneMonthAgo)) {
                historyOneMonthAgoLabel.text = viewModelFactory.mapToViewModel(historicFuel).price
            }
        }
        if let threeMonthsAgo = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -3, toDate: today, options: nil) {
            if let historicFuel = self.fuel?.historicFuelAtDate(NSDate.lastSaturday(date: threeMonthsAgo)) {
                historyThreeMonthsAgoLabel.text = viewModelFactory.mapToViewModel(historicFuel).price
            }
        }
        
        if let sixMonthsAgo = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -6, toDate: today, options: nil) {
            if let historicFuel = self.fuel?.historicFuelAtDate(NSDate.lastSaturday(date: sixMonthsAgo)) {
                historySixMonthsAgoLabel.text = viewModelFactory.mapToViewModel(historicFuel).price
            }
        }
        
        if let oneYearAgo = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitYear, value: -1, toDate: today, options: nil) {
            if let historicFuel = self.fuel?.historicFuelAtDate(NSDate.lastSaturday(date: oneYearAgo)) {
                historyOneYearAgoLabel.text = viewModelFactory.mapToViewModel(historicFuel).price
            }
        }
    }
    
    
    
    
    // MARK: - iAd Delegate
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.tableView.tableFooterView = banner
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.tableView.tableFooterView = nil
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }
}
