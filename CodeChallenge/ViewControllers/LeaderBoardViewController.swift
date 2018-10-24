//
//  LeaderBoardViewController.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit

class LeaderBoardViewController: UITableViewController {
    
    private var leaderboardUsers = [LeaderboardUser]()
    private final let cellIdentifier: String = "leaderboardCell"
    private let workoutId: Int
    
    init(workoutId: Int) {
        self.workoutId = workoutId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
        // Make API call to get leaderboard response
        RequestManager.shared.getLeaderboard(forWorkoutId: workoutId, success: { [weak self] leaderBoardUserArray in
            self?.leaderboardUsers = leaderBoardUserArray
            self?.tableView.reloadData()
            self?.fetchLeaderBoardMetrics()
        }, onError: { error in
            print("Leaderboard Error: \(error.localizedDescription)")
        })
    }
    
    private func fetchLeaderBoardMetrics() {
        let start = DispatchTime.now() // start time
        var urls = [URL]()
        for user in leaderboardUsers {
            if let url = URL(string: user.logURLPath) {
                urls.append(url)
            }
        }
        
        RequestManager.shared.fetchLeaderBoardMetrics(fromUrls: urls, completionHandler: { arrayOfArrayMetrics in
            for x in arrayOfArrayMetrics {
                print(x)
            }
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
            
            print("Time to download and clean leaderboard metrics: \(timeInterval) seconds")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        // loadLeaderboardDataFromJson()
        // let metrics = loadSampleMetricsFromJson(fileName: "SampleMetrics1")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = leaderboardUsers[indexPath.row].user.username
        return cell
    }
    
    private func loadLeaderboardDataFromJson(fileName: String) {
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: fileName, ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let leaderboardResponse = try JSONDecoder().decode([LeaderboardRawResponse].self, from: simulatedJsonData)
                
                // Here I remove any decoded structs that have nil values were a value is required
                var leaderboardUsers = [LeaderboardUser]()
                for response in leaderboardResponse {
                    if let leaderboardUser = LeaderboardUser(rawResponse: response) {
                        leaderboardUsers.append(leaderboardUser)
                    }
                }
                print("leaderboardUsers: \(leaderboardUsers)")
                
            } catch {
                print("\n\nError thrown loading leaderboard data from JSON: \(error)")
            }
        } else {
            print("Error: Could not load JSON data")
        }
    }
    
    private func loadSampleMetricsFromJson(fileName: String) -> [Metric] {
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: fileName, ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let rawMetrics = try JSONDecoder().decode([RawMetric].self, from: simulatedJsonData)
                return LeaderboardHelper.shared.cleanUserMetrics(singleUsersMetrics: rawMetrics)
            } catch {
                print("\n\nError thrown loading metirc data from JSON: \(error)")
                return []
            }
        } else {
            print("Error: Could not load JSON data")
            return []
        }
    }
}
