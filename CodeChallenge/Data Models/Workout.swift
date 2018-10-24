//
//  StudioClass.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

struct WorkoutRawResponse: Codable {
    // Decoding this wasn't a requirement for this challenge so I didn't worry too much about nil values for this JSON
    let id, instructorID, audioID: Int
    let name: String
    let backgroundURL: String
    let publishDate: String
    let duration: String
    let difficulty: String
    let description: String?
    let isWelcomeRun: Bool
    let type, musicGenre: String
    let equipment: String
    let usersTook: Int
    let instructor: Instructor?
    let audio: Audio?
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

    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? -1
        self.instructorID = try container.decodeIfPresent(Int.self, forKey: .instructorID) ?? -1
        self.audioID = try container.decodeIfPresent(Int.self, forKey: .audioID) ?? -1
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.backgroundURL = try container.decodeIfPresent(String.self, forKey: .backgroundURL) ?? ""
        self.publishDate = try container.decodeIfPresent(String.self, forKey: .publishDate) ?? ""
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration) ?? ""
        self.difficulty = try container.decodeIfPresent(String.self, forKey: .difficulty) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.isWelcomeRun = try container.decodeIfPresent(Bool.self, forKey: .description) ?? false
        self.type = try container.decodeIfPresent(String.self, forKey: .type) ?? ""
        self.musicGenre = try container.decodeIfPresent(String.self, forKey: .musicGenre) ?? ""
        self.equipment = try container.decodeIfPresent(String.self, forKey: .equipment) ?? ""
        self.usersTook = try container.decodeIfPresent(Int.self, forKey: .usersTook) ?? -1
        self.instructor = try container.decodeIfPresent(Instructor.self, forKey: .instructor)
        self.audio = try container.decodeIfPresent(Audio.self, forKey: .audio)
        self.topUsers = try container.decodeIfPresent([TopUser].self, forKey: .topUsers) ?? []
        self.workoutSession = try container.decodeIfPresent(WorkoutSession.self, forKey: .workoutSession)
        self.weights = try container.decodeIfPresent([Weight].self, forKey: .weights)
        self.isBookmarked = try container.decodeIfPresent(Bool.self, forKey: .isBookmarked) ?? false
    }
}

struct Workout {
    let id, instructorID, audioID: Int
    let name: String
    let backgroundURL: String
    let publishDate: String
    let duration: String
    let difficulty: String
    let description: String?
    let isWelcomeRun: Bool
    let type, musicGenre: String
    let equipment: String
    let usersTook: Int
    let instructor: Instructor
    let audio: Audio
    let topUsers: [TopUser]
    let workoutSession: WorkoutSession? // null in a lot of responses
    let weights: [Weight]? // // null in a lot of responses
    let isBookmarked: Bool
    
    init?(response: WorkoutRawResponse) {
        // I could make this more specific to filter out nil values, but it's not really part of the leaderboard
        if let instructor = response.instructor, let audio = response.audio {
            self.id = response.id
            self.instructorID = response.instructorID
            self.audioID = response.audioID
            self.name = response.name
            self.backgroundURL = response.backgroundURL
            self.publishDate = response.publishDate
            self.duration = response.duration
            self.difficulty = response.difficulty
            self.description = response.description
            self.isWelcomeRun = response.isWelcomeRun
            self.type = response.type
            self.musicGenre = response.musicGenre
            self.equipment = response.equipment
            self.usersTook = response.usersTook
            self.instructor = instructor
            self.audio = audio
            self.topUsers = response.topUsers
            self.workoutSession = response.workoutSession
            self.weights = response.weights
            self.isBookmarked = response.isBookmarked
        } else {
            // No workout without an instructor and audio
            return nil
        }
    }
}

struct Audio: Codable {
    let id: Int
    let name: String
    let url: String
}

//enum Difficulty: String, Codable {
//    case a = "A"
//    case b = "B"
//    case i = "I"
//    case u = "U"
//}

//enum Equipment: String, Codable {
//    case o = "O"
//    case t = "T"
//}

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
