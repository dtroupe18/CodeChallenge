//
//  WorkoutsTableViewController.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit

class WorkoutsTableViewController: UITableViewController {
    
    var workouts = [Workout]()
    
    private final let cellIdentifier: String = "workoutCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        // Make the API call to get available workouts!
        RequestManager.shared.getWorkouts(workoutArrray: { [weak self] workoutArray in
            self?.workouts = workoutArray
            self?.tableView.reloadData()
        }, onError: { error in
            print("error: \(error.localizedDescription)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(WorkoutCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WorkoutCell
        cell.configureWith(workout: workouts[indexPath.row])
        cell.hide()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let workoutCell = cell as? WorkoutCell {
            workoutCell.show()
        }
    }
}