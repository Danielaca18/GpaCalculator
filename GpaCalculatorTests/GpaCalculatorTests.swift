//
//  GpaCalculatorTests.swift
//  GpaCalculatorTests
//
//  Created by Daniel Castro on 2023-02-15.
//

import XCTest
@testable import Gpa_Calculator

final class GpaCalculatorTests: XCTestCase {
    var gpaC: GpaCalculatorApp!

    override func setUpWithError() throws {
        try super.setUpWithError()
        gpaC = GpaCalculatorApp()
    }

    override func tearDownWithError() throws {
        gpaC = nil
        try super.tearDownWithError()
    }
    
    /*
    * test add item function of content view
    */
    func addItemsTest() throws {
        let view = ContentView()
        for i in 0 ... 5 {
            var testName = UUID().uuidString
            testName = String(testName[..<testName.index(testName.startIndex, offsetBy: 9)])
            let testGpa = Float.random(in: 1..<10)
            let testCredit = Int.random(in: 1..<10)
            view.addItem()
            let courses = view.getItems()
            courses[0].name = testName
            courses[0].gpa = testGpa
            courses[0].credit = Int32(testCredit)
            XCTAssertTrue(courses.count == (i+1), "Course was not added successfuly")
            XCTAssertTrue(courses[i].name == testName, "Course name was not set properly")
            XCTAssertTrue(courses[i].gpa == testGpa, "Course gpa was not set properly")
            XCTAssertTrue(courses[i].credit == testCredit, "Course credit was not set properly")
            
        }
    }
    
    /*
    * test delete item function of content view
    */
    func deleteItemsTest() throws {
        let view = ContentView()
        for i in 0 ... 5 {
            view.addItem()
            let courses = view.getItems()
            XCTAssertTrue(courses.count == (i+1), "course list count off")
            view.deleteItems(offsets: IndexSet(integer: 0))
            XCTAssertTrue(courses.count == 0, "course list higher than expected")
        }
    }

    /*
    * performance not important in this context
    */
    func testPerformanceExample() throws {
        measure {
            
        }
    }

}
