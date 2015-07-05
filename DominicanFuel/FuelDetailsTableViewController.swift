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
import GoogleMobileAds

class FuelDetailsTableViewController: UITableViewController, ADBannerViewDelegate, GADBannerViewDelegate {

    @IBOutlet weak var tableViewHeaderImageView: FuelDetailsTableViewHeaderImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var timespanLabel: UILabel!
    @IBOutlet weak var historyOneMonthAgoLabel: UILabel!
    @IBOutlet weak var historyThreeMonthsAgoLabel: UILabel!
    @IBOutlet weak var historySixMonthsAgoLabel: UILabel!
    @IBOutlet weak var historyOneYearAgoLabel: UILabel!

   @IBOutlet weak var googleAdView: GADBannerView? {
        didSet {
            googleAdView?.delegate = self
            googleAdView?.rootViewController = self
            googleAdView?.adUnitID = "ca-app-pub-3743373903826064/5760698435"
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
        var request = GADRequest()
        request.testDevices = ["97cae6e4f669f3e8527d82ad261cc092", kGADSimulatorID]
        googleAdView?.loadRequest(request)
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

    // MARK: - Google Ad Banner View Delegate
    func adViewDidReceiveAd(view: GADBannerView!) {
        self.tableView.tableFooterView = view
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        println(error.localizedDescription)
        self.tableView.tableFooterView = nil
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
