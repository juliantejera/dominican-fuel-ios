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
            lineChart.headerPadding = 20.0
            lineChart.backgroundColor = UIColor.darkGrayColor()
        }
    }

    var visualEffectView: UIVisualEffectView!
    
    lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
        }()
    
    var fetchedResultsController: NSFetchedResultsController!
    lazy var fuelViewModelFactory = FuelViewModelFactory()
    
    var firstFuel: Fuel? {
        if let firstSection = self.fetchedResultsController.sections?.first as? NSFetchedResultsSectionInfo, let fuel = firstSection.objects.first as? Fuel {
            return fuel
        }
        return nil
    }
    
    var lastFuel: Fuel? {
        if let firstSection = self.fetchedResultsController.sections?.last as? NSFetchedResultsSectionInfo, let fuel = firstSection.objects.last as? Fuel {
            return fuel
        }
        return nil
    }
    
    lazy var leftToolbarItem: UIBarButtonItem =  {
       return UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: self, action: "didSelectLeftToolbarItem")
    }()
    
    lazy var rightToolbarItem: UIBarButtonItem =  {
        return UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: self, action: "didSelectRightToolbarItem")
    }()
    
    lazy var middleToolbarItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
    }()
    
    lazy var flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentCoordinator = DominicanFuelManagedDocumentCoordinator()
        documentCoordinator.delegate = self
        documentCoordinator.setupDocument()
        
        self.view.backgroundColor = UIColor.darkGrayColor()
        
        self.navigationController?.toolbarHidden = false
        self.toolbarItems = [self.leftToolbarItem,self.flexibleSpace, self.middleToolbarItem,self.flexibleSpace, self.rightToolbarItem]
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func didSelectLeftToolbarItem() {
        
    }
    
    func didSelectRightToolbarItem() {
        
    }
    
    func assignDefaultValues() {
        self.title = "Seleccione una línea"
        if let firstDate = firstFuel?.publishedAt, let lastDate = lastFuel?.publishedAt {
            self.leftToolbarItem.title = dateFormatter.stringFromDate(firstDate)
            self.middleToolbarItem.title = "---"
            self.rightToolbarItem.title = dateFormatter.stringFromDate(lastDate)
        }
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
                assignDefaultValues()
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.lineChart.reloadData()
        }, completion: nil)
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
        UIView.transitionWithView(self.view, duration: 0.6, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
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
    
    
    func shouldExtendSelectionViewIntoFooterPaddingForChartView(chartView: JBChartView!) -> Bool {
        return false
    }
    
    func shouldExtendSelectionViewIntoHeaderPaddingForChartView(chartView: JBChartView!) -> Bool {
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
            self.navigationItem.title = viewModel.type
            self.navigationItem.prompt = viewModel.timespan
            self.middleToolbarItem.title = "Precio: \(viewModel.price)"
            
            self.setTooltipVisible(true, animated: true, atTouchPoint: touchPoint)
            if fuel.delta > 0 {
                self.tooltipView.setText("😱")
            } else if fuel.delta < 0 {
                self.tooltipView.setText("😍")
            } else {
                self.tooltipView.setText("👀")
            }

        }
        
        
        self.leftToolbarItem.title = ""
        self.rightToolbarItem.title = ""

        
    }
    
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        self.setTooltipVisible(false, animated: true)
        self.navigationItem.title = nil
        self.navigationItem.prompt = nil
        assignDefaultValues()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return self.view.tintColor
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return self.view.tintColor
    }
    
    func lineChartView(lineChartView: JBLineChartView!, lineStyleForLineAtLineIndex lineIndex: UInt) -> JBLineChartViewLineStyle {
        return JBLineChartViewLineStyle.Solid
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 4.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 3.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, selectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return self.view.tintColor
    }
    
    func lineChartView(lineChartView: JBLineChartView!, selectionColorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return self.view.tintColor
    }
    
    override func chartView() -> JBChartView! {
        return lineChart
    }
    
    
}
