////
////  FuelTests.swift
////  DominicanFuel
////
////  Created by Julian Tejera on 3/18/15.
////  Copyright (c) 2015 Julian Tejera. All rights reserved.
////
//
//import UIKit
//import XCTest
//
//class FuelTests: XCTestCase {
//    var fuel: Fuel!
//    var mappedDictionary: [NSObject: AnyObject]!
//    var mappedFuel: Fuel!
//    override func setUp() {
//        super.setUp()
//        fuel = Fuel(id: 1, name: "Gasolina Premium", price: 222.52, publishedAt: NSDate(timeIntervalSince1970: 0))
//        mappedDictionary = fuel.toDictionary()
//        mappedFuel = Fuel(dictionary: mappedDictionary)
//    }
//    
//    override func tearDown() {
//        super.tearDown()
//    }
//    
//    func testInitId() {
//        let actual = fuel.id
//        let expected = 1
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
//    func testInitName() {
//        let actual = fuel.name
//        let expected = "Gasolina Premium"
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//
//    func testInitPrice() {
//        let actual = fuel.price
//        let expected = 222.52
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
//    func testInitPublishedAt() {
//        let actual = fuel.publishedAt!
//        let expected = NSDate(timeIntervalSince1970: 0)
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
//    func testConstant_kId() {
//        XCTAssertEqual(Fuel.kId(), "id")
//    }
//    
//    func testConstant_kName() {
//        XCTAssertEqual(Fuel.kName(), "name")
//    }
//    
//    func testConstant_kPrice() {
//        XCTAssertEqual(Fuel.kPrice(), "price")
//    }
//    
//    func testConstant_kPublishedAt() {
//        XCTAssertEqual(Fuel.kPublishedAt(), "publishedAt")
//    }
//    
//    
//    func testInitWithDictionary_Id() {
//        let actual = mappedFuel.id
//        let expected = 1
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
//    func testInitWithDictionary_Name() {
//        let actual = mappedFuel.name
//        let expected = "Gasolina Premium"
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
//    func testInitWithDictionary_Price() {
//        let actual = mappedFuel.price
//        let expected = 222.52
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
////    func testInitWithDictionary_PublishedAt() {
////        let actual = mappedFuel.id
////        let expected = 1
////        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
////    }
//    
//    func testToDictionary_Id() {
//        let actual = mappedDictionary[Fuel.kId()] as Int
//        let expected = 1
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
//    func testToDictionary_Name() {
//        let actual = mappedDictionary[Fuel.kName()] as String
//        let expected = "Gasolina Premium"
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
//    
//    func testToDictionary_Price() {
//        let actual = mappedDictionary[Fuel.kPrice()] as Double
//        let expected = 222.52
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//    
//    
//    func testToDictionary_PublishedAt() {
//        let actual = mappedDictionary[Fuel.kPublishedAt()] as NSDate
//        let expected = fuel.publishedAt!
//        XCTAssertEqual(actual, expected, "Expected '\(actual)' to be '\(expected)'")
//    }
//}
