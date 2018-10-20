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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        // Make the API call to get available workouts!
//        RequestManager.shared.getWorkouts(workoutArrray: { [weak self] workoutArray in
//            // self?.workouts = workoutArray
//            // self?.tableView.reloadData()
//            }, onError: { error in
//                print("error: \(error.localizedDescription)")
//        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        loadDataFromJson()
    }
    
    private func loadDataFromJson() {
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: "LeaderboardResponse", ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(LeaderboardResponse.self, from: simulatedJsonData)
                
                print("LeaderboardResponse: \(response)")
                
            } catch {
                print("Error thrown loading trends data from JSON: \(error)")
            }
        } else {
            print("could not load JSON data")
        }
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
