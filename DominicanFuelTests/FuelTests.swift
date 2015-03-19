//
//  FuelTests.swift
//  DominicanFuel
//
//  Created by Julian Tejera on 3/18/15.
//  Copyright (c) 2015 Julian Tejera. All rights reserved.
//

import UIKit
import XCTest

class FuelTests: XCTestCase {
    var fuel: Fuel!

    override func setUp() {
        super.setUp()
        fuel = Fuel(id: 1, name: "Gasolina Premium", price: 222.52, publishedAt: NSDate(timeIntervalSince1970: 0))
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitId() {
        let actual = fuel.id
        let expected = 1
        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
    }
    
    func testInitName() {
        let actual = fuel.name
        let expected = "Gasolina Premium"
        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
    }

    func testInitPrice() {
        let actual = fuel.price
        let expected = 222.52
        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
    }
    
    func testInitPublishedAt() {
        let actual = fuel.publishedAt!
        let expected = NSDate(timeIntervalSince1970: 0)
        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
    }
}
