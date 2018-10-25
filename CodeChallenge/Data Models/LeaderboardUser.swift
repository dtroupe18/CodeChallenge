//
//  LeaderboardUser.swift
//  CodeChallenge
//
//  Created by Dave on 10/24/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

struct LeaderboardUser {
    let user: User
    var workoutID: Int
    var distance: Double
    var heartRate: Double
    
    init(user: User, workoutID: Int, distance: Double, heartRate: Double) {
        self.user = user
        self.distance = distance
        self.heartRate = heartRate
        self.workoutID = workoutID
    }
    
    init(responseUser: LeaderboardEntry) {
        self.user = responseUser.user
        self.workoutID = responseUser.id
        self.distance = 0.0
        self.heartRate = 0.0
    }
    
    mutating func update(with distance: Double, heartRate: Double) {
        self.distance = distance
        self.heartRate = heartRate
    }
    
    static func == (lhs: LeaderboardUser, rhs: LeaderboardUser) -> Bool {
        return lhs.user.id == rhs.user.id
    }
}
