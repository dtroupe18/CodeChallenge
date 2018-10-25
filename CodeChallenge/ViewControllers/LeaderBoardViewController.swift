//
//  LeaderBoardViewController.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import Kingfisher

class LeaderBoardViewController: UITableViewController {
    
    private var leaderboardEntries = [LeaderboardEntry]() // Everyone returned by the API. Not all of these users are ranked
    private var leaderboardUsers = [LeaderboardUser]() // All the users who are ranked
    
    private var leaderboard = [Int: [Metric]]() // TimeInterval: Ranked User Metrics
    private var currentLeaderboard = [Metric]() // leaderboard at a particular timeInterval
    private var leaderboardTimer: Timer? // Keep track of when to update the leaderboard
    private var userScrolledLeaderboard: Bool = false
    
    private final let cellIdentifier: String = "leaderboardCell"
    private var cellHeights: [IndexPath: CGFloat] = [:]
    
    private let workoutId: Int
    private var currentTimeInterval: Int = 0
    private var selectedUser: LeaderboardUser? // User selected to simulate a real user
    private var doneInitialLoad: Bool = false
    
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
        CustomActivityIndicator.shared.show(uiView: view)
        RequestManager.shared.getLeaderboardEntries(forWorkoutId: workoutId, success: { [weak self] leaderboardEntries in
            self?.leaderboardEntries = leaderboardEntries
            self?.setLeaderboardUsers()
            self?.fetchLeaderBoardMetrics()
        }, onError: { [weak self] error in
            print("Leaderboard Error: \(error.localizedDescription)")
            if let sself = self {
                CustomActivityIndicator.shared.hide(uiView: sself.view)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        leaderboardTimer?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(LeaderboardCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 66
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.prefetchDataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startLeaderboard))
        // loadLeaderboardDataFromJson()
        // let metrics = loadSampleMetricsFromJson(fileName: "SampleMetrics1")
    }
    
    private func setLeaderboardUsers() {
        for (index, entry) in leaderboardEntries.enumerated() {
            let user = LeaderboardUser(responseUser: entry, rank: index + 1)
            leaderboardUsers.append(user)
        }
        self.tableView.reloadData()
    }
    
    private func fetchLeaderBoardMetrics() {
        let start = DispatchTime.now() // start time
        var urls = [URL]()
        for user in leaderboardEntries {
            if let url = URL(string: user.logURLPath) {
                urls.append(url)
            }
        }
        
        RequestManager.shared.fetchLeaderBoardMetrics(fromUrls: urls, completionHandler: { [weak self] leaderboard in
            self?.leaderboard = leaderboard
            let end = DispatchTime.now()
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let timeInterval = Double(nanoTime) / 1_000_000_000
            
            print("Time to download and clean leaderboard metrics: \(timeInterval) seconds")
            if let sself = self {
                CustomActivityIndicator.shared.hide(uiView: sself.view)
            }
        })
    }
    
    @objc private func startLeaderboard() {
        print("starting leaderboard")
        leaderboardTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateLeaderboard), userInfo: nil, repeats: true)
    }
    
    @objc private func updateLeaderboard() {
        currentTimeInterval += 5
        
        if let latestLeaderboard = leaderboard[currentTimeInterval] {
            // update the distance and heart rate for users then reload the tableview
            for metric in latestLeaderboard {
                if let i = leaderboardUsers.index(where: { $0.workoutID == metric.workoutSessionID }) {
                    leaderboardUsers[i].distance = metric.distance
                    if let hr = metric.heartRate {
                        leaderboardUsers[i].heartRate = hr
                    }
                }
            }
            let sorted = leaderboardUsers.sorted { $0.distance > $1.distance } // order by distance
            self.leaderboardUsers = leaderboardUsers.sorted { $0.distance > $1.distance } // order by distance
            for (newIndex, user) in leaderboardUsers.enumerated() {
                if let oldIndex = leaderboardUsers.index(where: {$0 == user }) {
                    leaderboardUsers[oldIndex].rank = newIndex + 1
                    if oldIndex != newIndex {
                        moveUser(from: oldIndex, to: newIndex)
                    }
                }
                if let cell = tableView.cellForRow(at: IndexPath(row: newIndex, section: 0)) as? LeaderboardCell {
                    cell.update(with: leaderboardUsers[newIndex])
                }
            }
            self.leaderboardUsers = sorted
            // self.tableView.reloadData()
            
            if let selectedLeaderboardUser = selectedUser {
                // Keep that cell pink
                if let index = leaderboardUsers.index(where: { $0 == selectedLeaderboardUser }) {
                    let indexPath = IndexPath(row: index, section: 0)
                    if !userScrolledLeaderboard {
                        // Scroll so this row is in the middle of the leaderboard
                        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
                    } else {
                        // User moved the leaderboard so we don't scroll it anymore
                        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    }
                }
            }
        }
    }

    private func moveUser(from oldIndex: Int, to newIndex: Int) {
        // Not used at the current moment, but could be used in the future to animate leaderboard updates
        let oldIndexPath = IndexPath(row: oldIndex, section: 0)
        let newIndexPath = IndexPath(row: newIndex, section: 0)
        UIView.animate(withDuration: 0.50, animations: {
            self.tableView.moveRow(at: oldIndexPath, to: newIndexPath)
        })
    }
    
    // Marker: TableView DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardUsers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! LeaderboardCell
        let row = indexPath.row
        let user = leaderboardUsers[row]
        
        if !doneInitialLoad {
            cell.configure(with: user, rank: row + 1)
        } else {
            cell.update(with: user)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Saving the cell heights allows for smoother scrolling because the height doesn't have to be recalculated
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 66.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = leaderboardUsers[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: tableView)
        if velocity.x != 0.0 || velocity.y != 0.0 {
            // user scrolled the leaderboard
            userScrolledLeaderboard = true
        }
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
                var leaderboardUsers = [LeaderboardEntry]()
                for response in leaderboardResponse {
                    if let leaderboardUser = LeaderboardEntry(rawResponse: response) {
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
                return LeaderboardHelper.shared.cleanUserMetrics(singleUsersMetrics: rawMetrics, workoutID: nil)
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

// Marker: Prefetching
extension LeaderBoardViewController: UITableViewDataSourcePrefetching {
    // Starts loading user images ahead of the users current scroll position.
    // These images are also cached
    
    private func getImageUrls(for indexPaths: [IndexPath]) -> [URL] {
        var urls = [URL]()
        for indexPath in indexPaths {
            if indexPath.row < leaderboardUsers.count {
                if let url = URL(string: leaderboardUsers[indexPath.row].user.avatarURL) {
                    urls.append(url)
                }
            }
        }
        return urls
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls = getImageUrls(for: indexPaths)
        ImagePrefetcher(urls: urls).start()
    }
}
