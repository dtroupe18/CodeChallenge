//
//  LeaderboardUser.swift
//  CodeChallenge
//
//  Created by Dave on 10/24/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

struct LeaderboardUser: Equatable {
    let user: User
    var workoutID: Int
    var distance: Double
    var heartRate: Double
    var rank: Int
    
    init(user: User, workoutID: Int, distance: Double, heartRate: Double, rank: Int) {
        self.user = user
        self.distance = distance
        self.heartRate = heartRate
        self.workoutID = workoutID
        self.rank = rank
    }
    
    init(responseUser: LeaderboardEntry, rank: Int) {
        self.user = responseUser.user
        self.workoutID = responseUser.id
        self.distance = 0.0
        self.heartRate = 0.0
        self.rank = rank
    }
    
    mutating func update(with distance: Double, heartRate: Double, rank: Int) {
        self.distance = distance
        self.heartRate = heartRate
        self.rank = rank
    }
    
    static func == (lhs: LeaderboardUser, rhs: LeaderboardUser) -> Bool {
        return lhs.user.id == rhs.user.id
    }
}
