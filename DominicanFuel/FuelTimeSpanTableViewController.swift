//
//  FuelTimeSpanTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 4/8/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FuelTimeSpanTableViewController: UITableViewController, ManagedDocumentCoordinatorDelegate, UIPopoverPresentationControllerDelegate {

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        refresh()
    }
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        // Handle error
        println("Error: \(error)")
    }
    
    func refresh() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            request.propertiesToFetch = ["publishedAt"]
            request.resultType = NSFetchRequestResultType.DictionaryResultType
            request.returnsDistinctResults = true
            var publishedAtDescending = NSSortDescriptor(key: "publishedAt", ascending: false, selector: "compare:")
            request.sortDescriptors = [publishedAtDescending]
            
            var error: NSError? = nil
            if let result = managedObjectContext.executeFetchRequest(request, error: &error) as? [[String: NSDate]] {
                for dictionary in result {
                    for (key, date) in dictionary {
                        dates.append(date)
                    }
                }
                self.tableView.reloadData()
            } else {
                println("Error: \(error)")
            }
        }
    }
    

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimespanCell", forIndexPath: indexPath) as UITableViewCell
       
        var date = dates[indexPath.row]
        var effectiveUntil = NSDate(timeInterval: 60*60*24*6, sinceDate: date)
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
                vc.document = self.document
                if let cell = sender as? UITableViewCell {
                    if let indexPath = self.tableView.indexPathForCell(cell) {
                        vc.selectedDate = self.dates[indexPath.row]
                    }
                }
            }
        }
    }

}
