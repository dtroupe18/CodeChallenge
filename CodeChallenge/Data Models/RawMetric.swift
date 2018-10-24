//
//  RawMetric.swift
//  CodeChallenge
//
//  Created by Dave on 10/23/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

struct RawMetric: Codable {
    let workoutSessionID: Int
    var timeInterval: Int
    let type: String
    let currentTimestamp: Int
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case workoutSessionID = "workout_session_id"
        case timeInterval = "time_interval"
        case type
        case currentTimestamp = "current_timestamp"
        case value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.workoutSessionID = try container.decodeIfPresent(Int.self, forKey: .workoutSessionID) ?? -1
        self.timeInterval = try container.decodeIfPresent(Int.self, forKey: .timeInterval) ?? -1
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.currentTimestamp = try container.decodeIfPresent(Int.self, forKey: .currentTimestamp) ?? -1
        self.value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
    }
    
    mutating func normalizeTimeInterval() {
        // The time intervals aren't consistent which makes matching up users metrics more challenging
        // Here I round the time intervals to every 5 seconds because that appears to be the most
        // consistent spacing in the data I looked at
        timeInterval = ((timeInterval + 4)/5) * 5
    }
}

struct Metric: Equatable {
    // I made this struct because I don't like how the response has multiple lines for the same interval
    // Using this allows one time interval to have both HR and distance
    let workoutSessionID: Int
    let timeInterval: Int
    let heartRate: Double?
    let distance: Double
    
    init?(distanceRawMetric: RawMetric, heartRate: Double?) {
        guard let distance = distanceRawMetric.value.doubleValue() else { return nil }
        self.workoutSessionID = distanceRawMetric.workoutSessionID
        self.timeInterval = distanceRawMetric.timeInterval
        self.distance = distance
        self.heartRate = heartRate
    }
    
    static func == (lhs: Metric, rhs: Metric) -> Bool {
        // Also have to worry about the fact that time intervals are repeated
        // This will be used so that there is only one metric for a given timeInterval
        return lhs.timeInterval == rhs.timeInterval
    }
}



