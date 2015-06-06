//
//  FuelTimeSpanTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/8/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelTimespanTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, ManagedDocumentCoordinatorDelegate {

    var document: UIManagedDocument?
    
    var dates = [NSDate]()
    
    lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let documentCoordinator = DominicanFuelManagedDocumentCoordinator()
        documentCoordinator.delegate = self
        documentCoordinator.setupDocument()
        populateDates(NSDate.lastSaturday())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateDates(date: NSDate) {
        let oneYearInWeeks = 52
        let oneWeekInSeconds: NSTimeInterval = 60*60*24*7
        var saturday = date
        do {
            dates.append(saturday)
            saturday = NSDate(timeInterval: -oneWeekInSeconds, sinceDate: saturday)
        } while (dates.count < (oneYearInWeeks * 6))
    }
    
    func mostRecentFuel() -> Fuel? {
        var request = NSFetchRequest(entityName: Fuel.entityName())
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return document?.managedObjectContext.executeFetchRequest(request, error: nil)?.first as? Fuel
    }
    
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        
        if let fuel = mostRecentFuel(), let publishedAt = fuel.publishedAt {
            dates.insert(publishedAt, atIndex: 0)
            tableView.reloadData()
        }
    }
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        println("Error: \(error)")
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimespanCell", forIndexPath: indexPath) as! UITableViewCell
       
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
                        vc.document = self.document
                    }
                }
            }
        }
    }

}
