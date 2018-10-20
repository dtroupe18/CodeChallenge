//
//  StudioClass.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

struct Workout: Codable {

    let id, instructorID, audioID: Int
    let name: String
    let backgroundURL: String
    let publishDate: String
    
    let duration: String
    let difficulty: Difficulty
    let description: String?
    let isWelcomeRun: Bool
    let type, musicGenre: String
    let equipment: Equipment
    let usersTook: Int
    let instructor: Instructor
    let audio: Audio
    let topUsers: [TopUser]
    let workoutSession: WorkoutSession?
    let weights: [Weight]?
    let isBookmarked: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case instructorID = "instructor_id"
        case audioID = "audio_id"
        case name
        case backgroundURL = "background_url"
        case publishDate = "publish_date"
        case duration, difficulty, description
        case isWelcomeRun = "is_welcome_run"
        case type
        case musicGenre = "music_genre"
        case equipment
        case usersTook = "users_took"
        case instructor, audio
        case topUsers = "top_users"
        case workoutSession = "workout_session"
        case weights
        case isBookmarked = "is_bookmarked"
    }
}

struct Audio: Codable {
    let id: Int
    let name: String
    let url: String
}

enum Difficulty: String, Codable {
    case a = "A"
    case b = "B"
    case i = "I"
}

enum Equipment: String, Codable {
    case o = "O"
    case t = "T"
}

struct Instructor: Codable {
    let id: Int
    let name: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case avatarURL = "avatar_url"
    }
}

struct TopUser: Codable {
    let id: Int
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
    }
}

struct Weight: Codable {
    let id, workoutID: Int
    let type: WorkoutType
    let howMany: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case workoutID = "workout_id"
        case type
        case howMany = "how_many"
        case createdAt = "created_at"
    }
}

enum WorkoutType: String, Codable {
    case h = "H"
    case l = "L"
    case m = "M"
}

struct WorkoutSession: Codable {
    let id, workoutID, userID: Int
    let filename: String
    let logURLPath: String
    let maxDistance, maxHeartRate, maxSpeed, points: Int
    let slug, duration: String
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
        case points, slug, duration
        case createdAt = "created_at"
    }
}
