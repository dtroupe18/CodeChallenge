//
//  WorkoutsTableViewController.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit

class WorkoutsViewController: UITableViewController {
    
    private var workouts = [Workout]()
    
    private final let cellIdentifier: String = "workoutCell"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        // Make API call to get available workouts
        RequestManager.shared.getWorkouts(workoutArrray: { [weak self] workoutArray in
            self?.workouts = workoutArray
            self?.tableView.reloadData()
        }, onError: { error in
            print("error: \(error.localizedDescription)")
        })
        
        // loadWorkoutDataFromJson()
    }
    
    private func loadWorkoutDataFromJson() {
        let bundle: Bundle = Bundle(for: type(of: self))
        if let path: String = bundle.path(forResource: "ClassesResponse", ofType: "json") {
            let url: URL = URL(fileURLWithPath: path)
            
            do {
                let simulatedJsonData: Data = try Data(contentsOf: url)
                let workouts = try JSONDecoder().decode([WorkoutRawResponse].self, from: simulatedJsonData)
                
                print("Workouts: \(workouts)")
                
            } catch {
                print("Error thrown loading trends data from JSON: \(error)")
            }
        } else {
            print("could not load JSON data")
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("workoutID: \(workouts[indexPath.row].id)")
        let leaderboardVC = LeaderBoardViewController(workoutId: workouts[indexPath.row].id)
        self.navigationController?.pushViewController(leaderboardVC, animated: true)
    }
}
