//
//  ChartTimeSpanTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/11/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class ChartTimespanTableViewController: UITableViewController {
    
    var titles = ["Último mes", "Últimos tres meses", "Últimos seis meses", "Último año", "Último dos años", "Último tres años", "Último cuatro años", "Último cinco años"]
    var dates = [NSDate]()
    
    var document: UIManagedDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "populateDates", forControlEvents: UIControlEvents.ValueChanged)
        populateDates()
    }
    
    func populateDates() {
        var lastSaturday = NSDate.lastSaturday().beginningOfDay
        dates.removeAll(keepCapacity: true)
        dates.append(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -1, toDate: lastSaturday, options: nil)!)
        dates.append(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -3, toDate: lastSaturday, options: nil)!)
        dates.append(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -6, toDate: lastSaturday, options: nil)!)
        dates.append(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitYear, value: -1, toDate: lastSaturday, options: nil)!)
        dates.append(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitYear, value: -2, toDate: lastSaturday, options: nil)!)
        dates.append(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitYear, value: -3, toDate: lastSaturday, options: nil)!)
        dates.append(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitYear, value: -4, toDate: lastSaturday, options: nil)!)
        dates.append(NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitYear, value: -5, toDate: lastSaturday, options: nil)!)
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChartTimespanCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = titles[indexPath.row]

        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ChartsSegue" {
            if let vc = segue.destinationViewController.contentViewController as? ChartViewController {
                if let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPathForCell(cell) {
                    vc.selectedDate = self.dates[indexPath.row]
                    vc.document = document
                }
            }
        }
    }
}
