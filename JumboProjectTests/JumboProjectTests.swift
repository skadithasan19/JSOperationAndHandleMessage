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

   let mainVC = ViewController()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testStartOperation() {
        let randomNum = Int(arc4random_uniform(UInt32(100 + 1)))
        mainVC.evaluateWithJavaScriptFunction(jsExpression: "startOeration(\(randomNum));") { (response, error) in
             XCTAssertNil(error, "No Error")
            XCTAssert(error == nil ? true : false)
        }
    }
    
    
    func testUserScript() {
        XCTAssert(mainVC.fetchScript() != nil)
    }

    func testMessageForOperation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            // your code here
            XCTAssert((self?.mainVC.messages.count ?? 0) > 0)
        }
        mainVC.startOperation()
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
