//
//  RequestManager.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

enum RequestType: String {
    case get
    case post
}

enum EndPoint: String {
    case workoutDashboard = "workouts/dashboard"
    case userWorkoutDashboard = "workouts/dashboard?difficulty=&duration=&equipment=&instructor_id=&last_date=&last_workout_id=&music_genre=&program_id=9&type=&user_id=80452"
}

enum RequestError: String, Error {
    case badURL = "Error URL is not working!"
    case noData = "No Data!"
    case decodeFailed = "Failed to decode!"
    
    func getError(withCode code: Int) -> Error {
        return NSError(domain: "", code: code, userInfo: [NSLocalizedDescriptionKey : self.rawValue]) as Error
    }
}

// Generic callbacks
typealias ErrorCallback = (Error) -> Void
typealias DataCallback = (Data) -> Void

// Decoded callbacks (structs)
typealias WorkoutsCallback = ([Workout]) -> Void
typealias LeaderboardEntryCallback = ([LeaderboardEntry]) -> Void
typealias LeaderboardCallback = ([Int: [Metric]]) -> Void

class RequestManager {
    
    private init() {
        // Prevents another instance from being created
    }
    
    // Normally I'd hide this in a keys file, but I'm assuming this key comes from the user object so I would have access in the app
    private final let authKey: String = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo4MDQ1MiwiZW1haWwiOiJncGV2bnF4cGliXzE1MjAwMDY3OTlAdGZibncubmV0IiwiZXhwIjoxNTQ1MDg4MTE4fQ.XW6oejlwo6UMXNulPd37dsMbwVPpzwEjHiAobGzxeXs"
    private final let authField: String = "Authorization"
    private final let userAgent: String = "Studio/1.0.39 (live.studio.ios; build:163; iOS 11.4.1) Alamofire/4.7.2"
    private final let userField: String = "User-Agent"
    
    static let shared = RequestManager()
    
    private final let baseURL: String =  "https://dev.studioapi.club/"
    
    func makeGetRequest(urlAddition: String?, onSuccess: DataCallback?, onError: ErrorCallback?) {
        // This function can handle all GET requests. It returns datar which can then be decoded or an error
        var urlString = baseURL
        
        if let extraUrl = urlAddition {
            urlString += extraUrl
        }
        
        guard let url: URL = URL(string: urlString) else {
            onError?(RequestError.badURL.getError(withCode: 370))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: userField)
        request.setValue(authKey, forHTTPHeaderField: authField)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                DispatchQueue.main.async {
                    onError?(err)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    onError?(RequestError.noData.getError(withCode: 371))
                }
                return
            }
            DispatchQueue.main.async {
                onSuccess?(data)
            }
        }
        task.resume()
    }
    
    func getWorkouts(workoutArrray: WorkoutsCallback?, onError: ErrorCallback?) {
        makeGetRequest(urlAddition: EndPoint.workoutDashboard.rawValue, onSuccess: { data in
            let decoder = JSONDecoder()
            do {
                let workouts = try decoder.decode([WorkoutRawResponse].self, from: data)
                var properWorkouts = [Workout]()
                
                for workout in workouts {
                    if let properWorkout = Workout(response: workout) {
                        properWorkouts.append(properWorkout)
                    }
                }
                workoutArrray?(properWorkouts)
            } catch {
                onError?(RequestError.decodeFailed.getError(withCode: 372))
            }
            
        }, onError: { error in
            onError?(error)
        })
    }
    
    func getLeaderboardEntries(forWorkoutId id: Int, success: LeaderboardEntryCallback?, onError: ErrorCallback?) {
        let urlAddition = "workouts/\(id)/leaderboard"
        
        makeGetRequest(urlAddition: urlAddition, onSuccess: { data in
            do {
                // This is the raw response where the User and other values can be nil
                let leaderboardResponse = try JSONDecoder().decode([LeaderboardRawResponse].self, from: data)
                
                // Here I remove any decoded structs that have nil values were a value is required
                var leaderboardUsers = [LeaderboardEntry]()
                for response in leaderboardResponse {
                    if let leaderboardUser = LeaderboardEntry(rawResponse: response) {
                        leaderboardUsers.append(leaderboardUser)
                    }
                }
                success?(leaderboardUsers)
            } catch {
                onError?(error)
                // onError?(RequestError.decodeFailed.getError(withCode: 372))
            }
        }, onError: { error in
            print("Error: \(error)")
            onError?(error)
        })
    }
    
    func fetchLeaderBoardMetrics(fromUrls urls: [URL], completionHandler: LeaderboardCallback?) {
        
        var leaderboardMetrics = [[Metric]]() // array of arrays with each users metrics 
        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "serialQueue")
        
        urls.forEach { url in
            group.enter() // add download to this process
            URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                
                guard let data = data, error == nil else { group.leave(); return }
                var workoutID: String? // Using this because a lot of workouts have real data, but the sessionID is 0 for some reason
                do {
                    let rawMetrics = try JSONDecoder().decode([RawMetric].self, from: data)
                    let urlParts = url.absoluteString.components(separatedBy: "/")
                    if let lastUrlPart = urlParts.last {
                        let split = lastUrlPart.components(separatedBy: "-")
                        if var lastSplit = split.last {
                            lastSplit.removeLast(5)
                            workoutID = lastSplit
                        }
                    }
                    let metrics = LeaderboardHelper.shared.cleanUserMetrics(singleUsersMetrics: rawMetrics, workoutID: workoutID)
                
                    serialQueue.async {
                        leaderboardMetrics.append(metrics)
                        group.leave()
                    }
                } catch {
                    print("Decode Error: \(error)")
                    group.leave()
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            // this will be executed when for each group.enter() call, a group.leave() has been executed
            let leaderboard = LeaderboardHelper.shared.createLeaderboardDictionary(leaderboardMetrics: leaderboardMetrics)
            completionHandler?(leaderboard)
        }
    }
}
    

    
    
    
    
    
    
    
    
    

