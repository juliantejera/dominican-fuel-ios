//
//  FuelDetailsTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/17/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import QuartzCore

class FuelDetailsTableViewController: UITableViewController {

    @IBOutlet weak var tableViewHeaderImageView: FuelDetailsTableViewHeaderImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var deltaLabel: UILabel!
    @IBOutlet weak var timespanLabel: UILabel!
    @IBOutlet weak var historyOneMonthAgoLabel: UILabel!
    @IBOutlet weak var historyThreeMonthsAgoLabel: UILabel!
    @IBOutlet weak var historySixMonthsAgoLabel: UILabel!
    @IBOutlet weak var historyOneYearAgoLabel: UILabel!

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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableViewHeaderImageView?.layer.masksToBounds = true
        self.tableViewHeaderImageView?.layer.cornerRadius = tableViewHeaderImageView.frame.height / 2.0
        self.tableViewHeaderImageView?.layer.borderWidth = 4.0
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        if let fuelViewModel = self.fuelViewModel {
            let textToShare = fuelViewModel.description
            let controller = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            controller.popoverPresentationController?.barButtonItem = sender
            self.present(controller, animated: true, completion: nil)
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
        let today = Date()
        if let oneMonthAgo = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.month, value: -1, to: today, options: []) {
            if let historicFuel = self.fuel?.historicFuel(at: Date.lastSaturday(oneMonthAgo)) {
                historyOneMonthAgoLabel.text = viewModelFactory.mapToViewModel(historicFuel).price
            }
        }
        if let threeMonthsAgo = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.month, value: -3, to: today, options: []) {
            if let historicFuel = self.fuel?.historicFuel(at: Date.lastSaturday(threeMonthsAgo)) {
                historyThreeMonthsAgoLabel.text = viewModelFactory.mapToViewModel(historicFuel).price
            }
        }
        
        if let sixMonthsAgo = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.month, value: -6, to: today, options: []) {
            if let historicFuel = self.fuel?.historicFuel(at: Date.lastSaturday(sixMonthsAgo)) {
                historySixMonthsAgoLabel.text = viewModelFactory.mapToViewModel(historicFuel).price
            }
        }
        
        if let oneYearAgo = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.year, value: -1, to: today, options: []) {
            if let historicFuel = self.fuel?.historicFuel(at: Date.lastSaturday(oneYearAgo)) {
                historyOneYearAgoLabel.text = viewModelFactory.mapToViewModel(historicFuel).price
            }
        }
    }
}
