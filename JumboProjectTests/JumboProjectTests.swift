//
//  JumboProjectTests.swift
//  JumboProjectTests
//
//  Created by Hasan, MdAdit on 2/20/20.
//  Copyright © 2020 Hasan, MdAdit. All rights reserved.
//

import XCTest
@testable import JumboProject

class JumboProjectTests: XCTestCase {

   let mainVC = JMWebViewModel()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartOperation() {
        let randomNum = Int(arc4random_uniform(UInt32(100 + 1)))
        mainVC.evaluateWithJSFunction(count: randomNum) { (response, error) in
             XCTAssertNil(error, "No Error")
            XCTAssert(error == nil ? true : false)
        }
    }
      
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
