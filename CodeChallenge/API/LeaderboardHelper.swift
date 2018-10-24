//
//  LeaderboardHelper.swift
//  CodeChallenge
//
//  Created by Dave on 10/24/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

class LeaderboardHelper {
    
    static let shared = LeaderboardHelper()
    
    private init() {}
    
    func cleanUserMetrics(singleUsersMetrics: [RawMetric]) -> [Metric] {
        let filtered = singleUsersMetrics.filter { $0.timeInterval != -1 && $0.type != "" && $0.workoutSessionID != -1 && $0.value != ""}
        var normalized = [RawMetric]()
        
        for var rawMetric in filtered {
            rawMetric.normalizeTimeInterval()
            normalized.append(rawMetric)
        }
        
        let heartRateMetrics = normalized.filter { $0.type == "HR" }
        let distanceMetrics = normalized.filter { $0.type == "D"}
        
        var betterMetrics = [Metric]()
        // Convert rawMetric into a metric so Distance and HR and in the same struct
        for distanceMetric in distanceMetrics {
            // Check and see if there's a HR for this time interval
            let hr = heartRateMetrics.filter { $0.timeInterval == distanceMetric.timeInterval }.first?.value.doubleValue()
            if let betterMetric = Metric(distanceRawMetric: distanceMetric, heartRate: hr) {
                // remove duplicates
                if !betterMetrics.contains(betterMetric) {
                    betterMetrics.append(betterMetric)
                }
            }
        }
        return betterMetrics
    }
}
