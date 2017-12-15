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
    var selectedDate: Date! = (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.month, value: -1, to: Date(), options: NSCalendar.Options.matchFirst) {
        didSet {
            reloadFetchedResultsController()
        }
    }
    
    var filter: FuelFilter?
    
    @IBOutlet weak var priceLabel: UILabel! {
        didSet {
            priceLabel.textColor = .black
        }
    }
    @IBOutlet weak var deltaLabel: UILabel!
    
    
    @IBOutlet weak var lineChart: JBLineChartView! {
        didSet {
            lineChart.delegate = self
            lineChart.dataSource = self
            lineChart.headerPadding = 20.0
            lineChart.footerPadding = 10.0
            lineChart.backgroundColor = .white
        }
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    lazy var dateFormatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        return formatter
        }()
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
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
        self.view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        if let chartRange = ChartRangeSegment(rawValue: sender.selectedSegmentIndex) {
            self.selectedDate = chartRange.date
        }
    }

    func reloadFetchedResultsController() {
        if let managedObjectContext = document?.managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: Fuel.entityName())
            let type = self.filter?.type ?? "Gasolina Premium"
            request.predicate = NSPredicate(format: "publishedAt >= %@ AND type IN %@", selectedDate.beginningOfDay as NSDate, [type])
            let typeAscending = NSSortDescriptor(key: "type", ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            let publishedAtAscending = NSSortDescriptor(key: "publishedAt", ascending: true, selector: #selector(NSNumber.compare(_:)))
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
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.lineChart?.reloadData()
        }, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.reloadFetchedResultsController()
    }
    
    
    // MARK: JBLineChartView Data Source
    
    func numberOfLines(in lineChartView: JBLineChartView!) -> UInt {
        return UInt(self.fetchedResultsController?.sections?.count ?? 0)
    }

    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if let section = self.fetchedResultsController?.sections?[Int(lineIndex)] {
            return UInt(section.numberOfObjects)
        }
        return 0
    }
    
    
    func shouldExtendSelectionViewIntoFooterPadding(for chartView: JBChartView!) -> Bool {
        return true
    }
    
    func shouldExtendSelectionViewIntoHeaderPadding(for chartView: JBChartView!) -> Bool {
        return true
    }
    // MARK: Line Chart View Delegate
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        let indexPath = IndexPath(row: Int(horizontalIndex), section: Int(lineIndex))
        
        if let fuel = self.fetchedResultsController?.object(at: indexPath) as? Fuel {
            return CGFloat(fuel.price)
        }
        return 0.0
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, didSelectLineAt lineIndex: UInt, horizontalIndex: UInt, touch touchPoint: CGPoint) {
        let indexPath = IndexPath(row: Int(horizontalIndex), section: Int(lineIndex))
        guard let fuel = self.fetchedResultsController?.object(at: indexPath) as? Fuel else {
            return
        }
        
        let viewModel = fuelViewModelFactory.mapToViewModel(fuel)
        priceLabel.text = viewModel.price
        deltaLabel.text = viewModel.delta
        deltaLabel.textColor = self.assetsManager.colorForDelta(fuel.delta)
        setTooltipVisible(true, animated: true, atTouch: touchPoint)
        tooltipView.textLabel.backgroundColor = view.tintColor
        tooltipView.textLabel.textColor = .white
        tooltipView.setText(viewModel.timespan)
    }
    
    func didDeselectLine(in lineChartView: JBLineChartView!) {
        self.setTooltipVisible(false, animated: true)
        assignDefaultValues()
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return self.view.tintColor
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return self.view.tintColor
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, lineStyleForLineAtLineIndex lineIndex: UInt) -> JBLineChartViewLineStyle {
        return .solid
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 4.0
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 4.0
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return false
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, selectionColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return self.view.tintColor
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, selectionColorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return self.view.tintColor
    }
    
    
    override func chartView() -> JBChartView! {
        return lineChart
    }
    
}


enum ChartRangeSegment: Int {
    case oneMonth
    case threeMonths
    case sixMonths
    case oneYear
    case twoYears
    case threeYears
    
    var date: Date {
        let lastSaturday = Date.lastSaturday().beginningOfDay
        
        switch self {
        case .oneMonth:
            return (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.month, value: -1, to: lastSaturday, options: [])!
        case .threeMonths:
            return (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.month, value: -3, to: lastSaturday, options: [])!
        case .sixMonths:
            return (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.month, value: -6, to: lastSaturday, options: [])!
        case .oneYear:
            return (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.year, value: -1, to: lastSaturday, options: [])!
        case .twoYears:
            return (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.year, value: -2, to: lastSaturday, options: [])!
        case .threeYears:
            return (Calendar.current as NSCalendar).date(byAdding: NSCalendar.Unit.year, value: -3, to: lastSaturday, options: [])!
        }
    }
}


