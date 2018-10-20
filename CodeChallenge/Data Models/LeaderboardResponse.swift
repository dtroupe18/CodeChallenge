//
//  LeaderboardResponse.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

typealias LeaderboardResponse = [LeaderboardUser]

struct LeaderboardUser: Codable {
    let id, workoutID, userID: Int
    let filename: String
    let logURLPath: String
    let maxDistance, maxHeartRate, maxSpeed, maxHeartRateAge: Int
    let heartRatePercentage, points: Int
    let slug: String
    let user: User
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case workoutID = "workout_id"
        case userID = "user_id"
        case filename
        case logURLPath = "log_url_path"
        case maxDistance = "max_distance"
        case maxHeartRate = "max_heart_rate"
        case maxSpeed = "max_speed"
        case maxHeartRateAge = "max_heart_rate_age"
        case heartRatePercentage = "heart_rate_percentage"
        case points, slug, user
        case createdAt = "created_at"
    }
}

struct User: Codable {
    let id: Int
    let username, email, birthday: String
    let age: Int
    let gender, location: String
    let weight: Int
    let subscription: String
    let subscriptionData, whyRunningWith: String? // always null in sample data
    let onboardingFinished: Bool
    let avatarURL: String
    let fbUserID, fbData, token, label: String? // always null in sample data
    let workoutSessionsCount: Int
    let createdAt: String
    let ranking: String? // always null in sample data
    
    enum CodingKeys: String, CodingKey {
        case id, username, email, birthday, age, gender, location, weight, subscription
        case subscriptionData = "subscription_data"
        case whyRunningWith = "why_running_with"
        case onboardingFinished = "onboarding_finished"
        case avatarURL = "avatar_url"
        case fbUserID = "fb_user_id"
        case fbData = "fb_data"
        case token, label
        case workoutSessionsCount = "workout_sessions_count"
        case createdAt = "created_at"
        case ranking
    }
}
