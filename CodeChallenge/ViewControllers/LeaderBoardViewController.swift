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
    private var leaderboard = [Int: [Metric]]()
    private var currentLeaderboard = [Metric]() // leaderboard at a particular second
    private var leaderboardTimer: Timer?
    
    private final let cellIdentifier: String = "leaderboardCell"
    private let workoutId: Int
    private var currentTimeInterval: Int = 0
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leaderboardTimer?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: cellIdentifier)
        // loadLeaderboardDataFromJson()
        // let metrics = loadSampleMetricsFromJson(fileName: "SampleMetrics1")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startLeaderboard))
    }
    
    private func fetchLeaderBoardMetrics() {
        let start = DispatchTime.now() // start time
        var urls = [URL]()
        for user in leaderboardUsers {
            if let url = URL(string: user.logURLPath) {
                urls.append(url)
            }
        }
        
        RequestManager.shared.fetchLeaderBoardMetrics(fromUrls: urls, completionHandler: { [weak self] leaderboard in
            //            var timeKeys = leaderboard.keys
            //            let sortedTimeKeys = timeKeys.sorted { $0 < $1 }
            //            print(sortedTimeKeys)
            //
            //            if let firstKey = sortedTimeKeys.first {
            //                print(leaderboard[firstKey])
            //            }
            self?.leaderboard = leaderboard
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            
            print("Time to download and clean leaderboard metrics: \(timeInterval) seconds")
        })
    }
    
    @objc private func startLeaderboard() {
        print("starting leaderboard")
        leaderboardTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateLeaderboard), userInfo: nil, repeats: true)
    }
    
    @objc private func updateLeaderboard() {
        print("updating leaderboard!")
        currentTimeInterval += 5
        print("currentTimeInterval: \(currentTimeInterval)")
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LeaderboardCell
        let row = indexPath.row
        cell.configure(with: leaderboardUsers[row], rank: row) // users start in arbitrary order
        return cell
    }
    
    // Marker: Load simulated data
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
