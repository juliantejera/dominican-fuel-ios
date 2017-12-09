//
//  FilterPickerTableViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 9/29/15.
//  Copyright © 2015 Julian Tejera. All rights reserved.
//

import UIKit

class FilterPickerTableViewController: CoreDataTableViewController {
    var document: UIManagedDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: FuelFilter.entityName())
            request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true, selector: #selector(NSNumber.compare(_:)))]
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Combustibles"
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterPickerCell", for: indexPath)
        
        if let filter = self.fetchedResultsController.object(at: indexPath) as? FuelFilter {
            cell.textLabel?.text = filter.type
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        self.title = ""
        if segue.identifier == "ChartsSegue" {
            if let chartViewController = segue.destination.contentViewController as? ChartViewController, let cell = sender as? UITableViewCell, let indexPath = self.tableView.indexPath(for: cell), let filter = self.fetchedResultsController.object(at: indexPath) as? FuelFilter  {
                chartViewController.document = self.document
                chartViewController.filter = filter
            }
        }
    }
    
}
