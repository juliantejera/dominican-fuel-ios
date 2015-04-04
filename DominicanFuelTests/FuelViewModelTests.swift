////
////  FuelViewModelTests.swift
////  DominicanFuel
////
////  Created by Julian Tejera on 3/25/15.
////  Copyright (c) 2015 Julian Tejera. All rights reserved.
////
//
//import UIKit
//import XCTest
//
//class FuelViewModelTests: XCTestCase {
//
//    var fuelViewModel: FuelViewModel!
//    override func setUp() {
//        super.setUp()
//        let fuel = Fuel(id: 1, name: "Gasolina Premium", price: 222.52, publishedAt: NSDate(timeIntervalSince1970: 0))
//        fuelViewModel = FuelViewModel(fuel: fuel)
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//
//    func testInitWithFuelName() {
//        let actual = fuelViewModel.name
//        let expected = "Gasolina Premium"
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//
//    }
//    
//    func testInitWithFuelPrice() {
//        let actual = fuelViewModel.price
//        let expected = "$222.52"
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//}
