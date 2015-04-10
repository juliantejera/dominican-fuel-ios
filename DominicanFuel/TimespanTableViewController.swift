//
//  FuelTimeSpanTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/8/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class TimespanTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {

    var dates = [NSDate]()
    
    lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        populateDates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateDates() {
        let oneYearInWeeks = 52
        let oneWeekInSeconds: NSTimeInterval = 60*60*24*7
        var saturday = NSDate.lastSaturday()
        do {
            dates.append(saturday)
            saturday = NSDate(timeInterval: -oneWeekInSeconds, sinceDate: saturday)
        } while (dates.count < oneYearInWeeks)
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimespanCell", forIndexPath: indexPath) as UITableViewCell
       
        var date = dates[indexPath.row]
        let sixDaysInSeconds: NSTimeInterval = 60*60*24*6
        var effectiveUntil = NSDate(timeInterval: sixDaysInSeconds, sinceDate: date)
        cell.textLabel?.text = "\(dateFormatter.stringFromDate(date)) - \(dateFormatter.stringFromDate(effectiveUntil))"
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "FuelsSegue" {
            if let vc = segue.destinationViewController.contentViewController as? FuelsTableViewController {
                if let cell = sender as? UITableViewCell {
                    if let indexPath = self.tableView.indexPathForCell(cell) {
                        vc.selectedDate = self.dates[indexPath.row]
                    }
                }
            }
        } else if segue.identifier == "ChartsSegue" {
            if let vc = segue.destinationViewController.contentViewController as? ChartsViewController {
                if let cell = sender as? UITableViewCell {
                    if let indexPath = self.tableView.indexPathForCell(cell) {
                        vc.selectedDate = self.dates[indexPath.row]
                    }
                }
            }
        }
    }

}
