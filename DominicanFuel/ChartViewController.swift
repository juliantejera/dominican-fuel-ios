//
//  ChartsViewController.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/26/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit

class ChartViewController: JBBaseChartViewController, JBLineChartViewDataSource, JBLineChartViewDelegate, UIPopoverPresentationControllerDelegate {

    var document: UIManagedDocument? 
    var selectedDate: NSDate! = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: NSDate(), options: NSCalendarOptions.MatchFirst) {
        didSet {
            reloadFetchedResultsController()
        }
    }
    
    var filter: FuelFilter?
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.textColor = UIColor.whiteColor()
        }
    }
    @IBOutlet weak var deltaLabel: UILabel!
    
    
    @IBOutlet weak var lineChart: JBLineChartView! {
        didSet {
            lineChart.delegate = self
            lineChart.dataSource = self
            lineChart.headerPadding = 20.0
            lineChart.footerPadding = 10.0
            lineChart.backgroundColor = UIColor.blackColor()
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
        }()
    
    var fetchedResultsController: NSFetchedResultsController!
    lazy var fuelViewModelFactory = FuelViewModelFactory()
    lazy var assetsManager = DeltaAssetsManager()

    var firstFuel: Fuel? {
        if let firstSection = self.fetchedResultsController.sections?.first, let fuel = firstSection.objects?.first as? Fuel {
            return fuel
        }
        return nil
    }
    
    var lastFuel: Fuel? {
        if let firstSection = self.fetchedResultsController.sections?.last, let fuel = firstSection.objects?.last as? Fuel {
            return fuel
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        reloadFetchedResultsController()
    }

    func assignDefaultValues() {
        if let fuel = self.lastFuel {
            self.title = fuel.type
            let viewModel = fuelViewModelFactory.mapToViewModel(fuel)
            self.priceLabel.text = viewModel.price
            self.deltaLabel.text = "\(viewModel.delta) esta semana"
            self.deltaLabel.textColor = assetsManager.colorForDelta(fuel.delta)
        }
    }
    
    @IBAction func segmentedControlDidChange(sender: UISegmentedControl) {
        if let chartRange = ChartRangeSegment(rawValue: sender.selectedSegmentIndex) {
            self.selectedDate = chartRange.date
        }
    }

    func reloadFetchedResultsController() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest(entityName: Fuel.entityName())
            let type = self.filter?.type ?? "Gasolina Premium"
            request.predicate = NSPredicate(format: "publishedAt >= %@ AND type IN %@", selectedDate.beginningOfDay, [type])
            let typeAscending = NSSortDescriptor(key: "type", ascending: true, selector: "localizedStandardCompare:")
            let publishedAtAscending = NSSortDescriptor(key: "publishedAt", ascending: true, selector: "compare:")
            request.sortDescriptors = [typeAscending, publishedAtAscending]
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: "type", cacheName: nil)
            
            do {
                try self.fetchedResultsController.performFetch()
                lineChart?.reloadData()
                self.assignDefaultValues()
            } catch _ {
            }
        }
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.lineChart?.reloadData()
        }, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        self.reloadFetchedResultsController()
    }
    
    
    // MARK: JBLineChartView Data Source
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return UInt(self.fetchedResultsController?.sections?.count ?? 0)
    }

    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if let section = self.fetchedResultsController?.sections?[Int(lineIndex)] {
            return UInt(section.numberOfObjects)
        }
        return 0
    }
    
    
    func shouldExtendSelectionViewIntoFooterPaddingForChartView(chartView: JBChartView!) -> Bool {
        return true
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
            self.priceLabel.text = viewModel.price
            self.deltaLabel.text = viewModel.delta
            self.deltaLabel.textColor = self.assetsManager.colorForDelta(fuel.delta)
            
            self.setTooltipVisible(true, animated: true, atTouchPoint: touchPoint)
            self.tooltipView.textLabel.backgroundColor = self.view.tintColor
            self.tooltipView.textLabel.textColor = UIColor.whiteColor()
            self.tooltipView.setText(viewModel.timespan)
        }
    }
    
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        self.setTooltipVisible(false, animated: true)
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
        return 2.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
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


enum ChartRangeSegment: Int {
    case OneMonth
    case ThreeMonths
    case SixMonths
    case OneYear
    case TwoYears
    case ThreeYears
    
    var date: NSDate {
        let lastSaturday = NSDate.lastSaturday().beginningOfDay
        
        switch self {
        case .OneMonth:
            return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: lastSaturday, options: [])!
        case .ThreeMonths:
            return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: -3, toDate: lastSaturday, options: [])!
        case .SixMonths:
            return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Month, value: -6, toDate: lastSaturday, options: [])!
        case .OneYear:
            return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Year, value: -1, toDate: lastSaturday, options: [])!
        case .TwoYears:
            return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Year, value: -2, toDate: lastSaturday, options: [])!
        case .ThreeYears:
            return NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Year, value: -3, toDate: lastSaturday, options: [])!
        }
    }
}


