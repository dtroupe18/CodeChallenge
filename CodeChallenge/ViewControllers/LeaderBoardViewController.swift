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
        }, onError: { error in
            print("Leaderboard Error: \(error.localizedDescription)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        // loadLeaderboardDataFromJson()
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
}
