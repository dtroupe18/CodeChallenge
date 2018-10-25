//
//  LeaderboardResponse.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

struct LeaderboardRawResponse: Codable {
    // All optional because we don't know what the backend will return
    let id, workoutID, userID: Int?
    let filename: String?
    let logURLPath: String?
    let maxHeartRate, maxSpeed, maxHeartRateAge: Int?
    let maxDistance: Double?
    let heartRatePercentage, points: Int?
    let slug: String?
    let user: User?
    let createdAt: String?
    
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.workoutID = try container.decodeIfPresent(Int.self, forKey: .workoutID)
        self.userID = try container.decodeIfPresent(Int.self, forKey: .userID)
        self.filename = try container.decodeIfPresent(String.self, forKey: .filename)
        self.logURLPath = try container.decodeIfPresent(String.self, forKey: .logURLPath)
        self.maxHeartRate = try container.decodeIfPresent(Int.self, forKey: .maxHeartRate)
        self.maxSpeed = try container.decodeIfPresent(Int.self, forKey: .maxSpeed)
        self.maxHeartRateAge = try container.decodeIfPresent(Int.self, forKey: .maxHeartRateAge)
        self.maxDistance = try container.decodeIfPresent(Double.self, forKey: .maxDistance)
        self.heartRatePercentage = try container.decodeIfPresent(Int.self, forKey: .heartRatePercentage)
        self.points = try container.decodeIfPresent(Int.self, forKey: .points)
        self.slug = try container.decodeIfPresent(String.self, forKey: .slug)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }
}

struct LeaderboardEntry {
    // Optional values for the things that aren't needed for the leaderboard
    let id, workoutID, userID: Int
    let filename: String?
    let logURLPath: String
    let maxHeartRate, maxSpeed, maxHeartRateAge: Int
    let maxDistance: Double?
    let heartRatePercentage, points: Int
    let slug: String?
    let user: User
    let createdAt: String?
    
    init?(rawResponse: LeaderboardRawResponse) {
        // Take a rawResponse and if it has all of the values we need then we return a LeaderboardUser
        // This avoids some problems with optionals later
        guard let user = rawResponse.user else { return nil }
        self.user = user
        
        guard let id = rawResponse.id else { return nil }
        self.id = id
        
        guard let workoutID = rawResponse.workoutID else { return nil }
        self.workoutID = workoutID
        
        guard let uid = rawResponse.userID else { return nil }
        self.userID = uid
        
        guard let logURL = rawResponse.logURLPath else { return nil }
        self.logURLPath = logURL
        
        guard let maxHR = rawResponse.maxHeartRate else { return nil }
        self.maxHeartRate = maxHR
        
        guard let maxSpeed = rawResponse.maxSpeed else { return nil }
        self.maxSpeed = maxSpeed
        
        guard let maxHeartRateAge = rawResponse.maxHeartRateAge else { return nil }
        self.maxHeartRateAge = maxHeartRateAge
        
        guard let heartRatePercentage = rawResponse.heartRatePercentage else { return nil }
        self.heartRatePercentage = heartRatePercentage
        
        guard let points = rawResponse.points else { return nil }
        self.points = points
        
        self.filename = rawResponse.filename
        self.slug = rawResponse.slug
        self.createdAt = rawResponse.createdAt
        self.maxDistance = rawResponse.maxDistance
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.username = try container.decodeIfPresent(String.self, forKey: .username) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.birthday = try container.decodeIfPresent(String.self, forKey: .birthday) ?? ""
        self.age = try container.decodeIfPresent(Int.self, forKey: .age) ?? -1
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender) ?? ""
        self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        self.weight = try container.decodeIfPresent(Int.self, forKey: .weight) ?? -1
        self.subscription = try container.decodeIfPresent(String.self, forKey: .subscription) ?? ""
        self.subscriptionData = try container.decodeIfPresent(String.self, forKey: .subscriptionData)
        self.whyRunningWith = try container.decodeIfPresent(String.self, forKey: .whyRunningWith)
        self.onboardingFinished = try container.decodeIfPresent(Bool.self, forKey: .onboardingFinished) ?? false
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL) ?? ""
        self.fbUserID = try container.decodeIfPresent(String.self, forKey: .fbUserID)
        self.fbData = try container.decodeIfPresent(String.self, forKey: .fbData)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
        self.label = try container.decodeIfPresent(String.self, forKey: .label)
        self.workoutSessionsCount = try container.decodeIfPresent(Int.self, forKey: .workoutSessionsCount) ?? -1
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.ranking = try container.decodeIfPresent(String.self, forKey: .ranking)
    }
}

