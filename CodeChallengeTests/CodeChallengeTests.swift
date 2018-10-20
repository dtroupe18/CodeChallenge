//
//  CodeChallengeTests.swift
//  CodeChallengeTests
//
//  Created by Dave on 10/19/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import XCTest
@testable import CodeChallenge

class CodeChallengeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func loadDataFromJson() {
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: "ClassesResponse", ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let workouts = try JSONDecoder().decode(WorkoutArray.self, from: simulatedJsonData)
                
                print("Workouts: \(workouts)")
                
            } catch {
                print("Error thrown loading trends data from JSON: \(error)")
            }
        } else {
            print("could not load JSON data")
        }
    }
}