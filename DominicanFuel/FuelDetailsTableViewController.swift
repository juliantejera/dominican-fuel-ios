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
    
    weak var fuel: Fuel? {
        didSet {
            if let fuel = self.fuel {
                self.fuelViewModel = FuelViewModelFactory().mapToViewModel(fuel)
            } else {
                self.fuelViewModel = nil
            }
        }
    }
    
    var fuelViewModel: FuelViewModel?

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
