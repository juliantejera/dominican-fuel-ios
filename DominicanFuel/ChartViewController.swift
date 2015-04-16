//
//  ChartsViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/26/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController, ManagedDocumentCoordinatorDelegate {

    var document: UIManagedDocument?
    var selectedDate: NSDate = NSDate.lastSaturday() {
        didSet {
            reloadChart()
        }
    }
    
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
    
   
    func reloadChart() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            let selectedFuelFiltersTypes = FuelFilter.selectedFuelFilters(managedObjectContext).map({ $0.type })
            if selectedFuelFiltersTypes.count > 0 {
                request.predicate = NSPredicate(format: "publishedAt >= %@ AND type IN %@", selectedDate.beginningOfDay, selectedFuelFiltersTypes)
            }
            let publishedAtAscending = NSSortDescriptor(key: "publishedAt", ascending: true, selector: "compare:")
            request.sortDescriptors = [publishedAtAscending]
            var error: NSError? = nil
            
            if let results = managedObjectContext.executeFetchRequest(request, error: &error) as? [Fuel] {

            }
        }
    }
    
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        reloadChart()
    }
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        // Handle error
        println("Error: \(error)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
