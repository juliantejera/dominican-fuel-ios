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

    @IBOutlet weak var tableViewHeaderImageView: UIImageView!
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
                self.fuelViewModel = factory.mapToViewModel(fuel)
            } else {
                self.fuelViewModel = nil
            }
        }
    }
    
    var fuelViewModel: FuelViewModel?

    lazy var factory = FuelViewModelFactory()
    lazy var upArrow = UIImage(named: "big_up_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var downArrow = UIImage(named: "big_down_arrow")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var equalSign = UIImage(named: "big_equal_sign")?.imageWithRenderingMode(.AlwaysTemplate)
    lazy var upArrowTintColor = UIColor.redColor()
    lazy var downArrowTintColor = UIColor.greenColor()
    lazy var equalSignTintColor = UIColor.orangeColor()
    
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
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    func updateUI() {
        self.title = fuelViewModel?.type
        self.priceLabel?.text = fuelViewModel?.price
        self.deltaLabel.text = fuelViewModel?.delta
        self.timespanLabel.text = fuelViewModel?.timespan
        
        if let fuel = self.fuel {
            updateImageView(tableViewHeaderImageView, delta: fuel.delta)
        }
        
        // Historic labels
        var today = NSDate()
        if let oneMonthAgo = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -1, toDate: today, options: nil) {
            if let historicFuel = self.fuel?.historicFuelAtDate(NSDate.lastSaturday(date: oneMonthAgo)) {
                historyOneMonthAgoLabel.text = factory.mapToViewModel(historicFuel).price
            }
        }
        if let threeMonthsAgo = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -3, toDate: today, options: nil) {
            if let historicFuel = self.fuel?.historicFuelAtDate(NSDate.lastSaturday(date: threeMonthsAgo)) {
                historyThreeMonthsAgoLabel.text = factory.mapToViewModel(historicFuel).price
            }
        }
        
        if let sixMonthsAgo = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -6, toDate: today, options: nil) {
            if let historicFuel = self.fuel?.historicFuelAtDate(NSDate.lastSaturday(date: sixMonthsAgo)) {
                historySixMonthsAgoLabel.text = factory.mapToViewModel(historicFuel).price
            }
        }
        
        if let oneYearAgo = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitYear, value: -1, toDate: today, options: nil) {
            if let historicFuel = self.fuel?.historicFuelAtDate(NSDate.lastSaturday(date: oneYearAgo)) {
                historyOneYearAgoLabel.text = factory.mapToViewModel(historicFuel).price
            }
        }
    }
    
    func updateImageView(imageView: UIImageView, delta: Double) {
        var selectedBorderColor: CGColor
        if delta > 0 {
            selectedBorderColor = upArrowTintColor.CGColor
            imageView.tintColor = upArrowTintColor
            imageView.image = upArrow
        } else if delta < 0 {
            selectedBorderColor = downArrowTintColor.CGColor
            imageView.tintColor = downArrowTintColor
            imageView.image = downArrow
        } else {
            selectedBorderColor = equalSignTintColor.CGColor
            imageView.tintColor = equalSignTintColor
            imageView.image = equalSign
        }
        
        var animation = CABasicAnimation(keyPath: "borderColor")
        animation.fromValue = UIColor.clearColor().CGColor
        animation.toValue = selectedBorderColor
        animation.duration = 3.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        imageView.layer.addAnimation(animation, forKey: "borderColor")
        imageView.layer.borderColor = selectedBorderColor
    }
}
