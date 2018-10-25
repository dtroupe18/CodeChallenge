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

    func testTimeIntervalNormalization() {
       let simulatedRawMetrics = loadSampleMetricsFromJson(fileName: "SampleMetrics1")
        
        var allMultipleOfFive: Bool = true
        var errorCount: Int = 0
        for metric in simulatedRawMetrics {
            // Check that all intervals were properly rounded
            
            if metric.timeInterval % 5 != 0 {
                allMultipleOfFive = false
                errorCount += 1
            }
        }
        XCTAssertTrue(allMultipleOfFive, "Not all time intervals were correctly rounded!")
        XCTAssertTrue(errorCount == 0, "Number of errors: \(errorCount)")
    }
    
    private func loadSampleMetricsFromJson(fileName: String) -> [RawMetric] {
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: fileName, ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let rawMetrics = try JSONDecoder().decode([RawMetric].self, from: simulatedJsonData)
                
                // Remove any metrics that are missing required values
                let filtered = rawMetrics.filter { $0.timeInterval != -1 && $0.type != "" && $0.workoutSessionID != -1 && $0.value != ""}
                
                var normalized = [RawMetric]()
                for var rawMetric in filtered {
                    rawMetric.normalizeTimeInterval()
                    normalized.append(rawMetric)
                }
                return normalized
                
            } catch {
                print("\n\nError thrown loading metirc data from JSON: \(error)")
                return []
            }
        } else {
            print("Error: Could not load JSON data")
            return []
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func loadWorkoutDataFromJson() {
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: "ClassesResponse", ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let workouts = try JSONDecoder().decode([WorkoutRawResponse].self, from: simulatedJsonData)
                
                print("Workouts: \(workouts)")
                
            } catch {
                print("Error thrown loading trends data from JSON: \(error)")
            }
        } else {
            print("could not load JSON data")
        }
    }
    
    private func loadLeaderboardDataFromJson(fileName: String) {
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: fileName, ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let leaderboardResponse = try JSONDecoder().decode([LeaderboardRawResponse].self, from: simulatedJsonData)
                
                // Here I remove any decoded structs that have nil values were a value is required
                var leaderboardUsers = [LeaderboardEntry]()
                for response in leaderboardResponse {
                    if let leaderboardUser = LeaderboardEntry(rawResponse: response) {
                        leaderboardUsers.append(leaderboardUser)
                    }
                }
                
                print("leaderboardUsers: \(leaderboardUsers)")
                
            } catch {
                print("\n\nError thrown loading trends data from JSON: \(error)")
            }
        } else {
            print("Error: Could not load JSON data")
        }
    }
}
