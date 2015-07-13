//
//  ChartsViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/26/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class ChartViewController: JBBaseChartViewController, ManagedDocumentCoordinatorDelegate, JBLineChartViewDataSource, JBLineChartViewDelegate, UIPopoverPresentationControllerDelegate {

    var document: UIManagedDocument?
    var selectedDate: NSDate! = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.CalendarUnitMonth, value: -1, toDate: NSDate(), options: NSCalendarOptions.MatchFirst) {
        didSet {
            reloadFetchedResultsController()
        }
    }
    
    @IBOutlet weak var lineChart: JBLineChartView! {
        didSet {
            lineChart.delegate = self
            lineChart.dataSource = self
            lineChart.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.9)
        }
    }
    @IBOutlet weak var stupidLabel: UILabel! {
        didSet {
            stupidLabel.numberOfLines = 0
        }
    }
    
    lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
        }()
    
    var fetchedResultsController: NSFetchedResultsController!
    lazy var fuelViewModelFactory = FuelViewModelFactory()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentCoordinator = DominicanFuelManagedDocumentCoordinator()
        documentCoordinator.delegate = self
        documentCoordinator.setupDocument()
        
        
    }
    
    
    func reloadFetchedResultsController() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            let selectedFuelFiltersTypes = FuelFilter.selectedFuelFilters(managedObjectContext).map({ $0.type })
            if selectedFuelFiltersTypes.count > 0 {
                request.predicate = NSPredicate(format: "publishedAt >= %@ AND type IN %@", selectedDate.beginningOfDay, selectedFuelFiltersTypes)
            }
            var typeAscending = NSSortDescriptor(key: "type", ascending: true, selector: "localizedStandardCompare:")
            let publishedAtAscending = NSSortDescriptor(key: "publishedAt", ascending: true, selector: "compare:")
            request.sortDescriptors = [typeAscending, publishedAtAscending]
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "type", cacheName: nil)
            
            var error: NSError?
            if self.fetchedResultsController.performFetch(&error) {
                lineChart.reloadData()
            }
        }
    }
    
    // MARK: - Managed Document Coordinator Delegate
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didOpenDocument document: UIManagedDocument) {
        self.document = document
        reloadFetchedResultsController()
    }
    
    func managedDocumentCoordinator(coordinator: ManagedDocumentCoordinator, didFailWithError error: NSError) {
        // Handle error
        println("Error: \(error)")
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "FilterSegue" {
            if let controller = segue.destinationViewController as? FilterTableViewController {
                controller.document = self.document
                controller.popoverPresentationController?.delegate = self
            }
        }
    }
    
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        UIView.transitionWithView(self.view, duration: 0.6, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.reloadFetchedResultsController()
            }) { (success) -> Void in
                // TODO
        }
    }
    
    
    // MARK: JBLineChartView Data Source
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return UInt(self.fetchedResultsController?.sections?.count ?? 0)
    }

    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if let section = self.fetchedResultsController?.sections?[Int(lineIndex)] as? NSFetchedResultsSectionInfo {
            return UInt(section.numberOfObjects)
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    
    // MARK: Line Chart View Delegate
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        let indexPath = NSIndexPath(forRow: Int(horizontalIndex), inSection: Int(lineIndex))
        
        if let fuel = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Fuel {
            return CGFloat(fuel.price)
        }
        return 0.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt, touchPoint: CGPoint) {
        let indexPath = NSIndexPath(forRow: Int(horizontalIndex), inSection: Int(lineIndex))
        if let fuel = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Fuel {
            let viewModel = fuelViewModelFactory.mapToViewModel(fuel)
            self.setTooltipVisible(true, animated: true, atTouchPoint: touchPoint)
            self.tooltipView.setText("1")
            self.navigationItem.title = viewModel.type
            self.stupidLabel.text = "\(viewModel.type)\n\(viewModel.timespan)\n\(viewModel.price)"
        }
        
    }
    
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        self.setTooltipVisible(false, animated: true)
        self.navigationItem.title = nil
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.redColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 5
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    
    override func chartView() -> JBChartView! {
        return lineChart
    }
}
