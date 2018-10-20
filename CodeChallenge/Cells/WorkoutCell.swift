//
//  WorkoutTableViewCell.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import Anchorage
import Kingfisher

class WorkoutCell: UITableViewCell {
    
    let instructorImageView = CircleImageView()
    let containerView = UIView()
    
    let workNameLabel = UILabel()
    let instructorNameLabel = UILabel()
    let idLabel = UILabel() // for debug purposes only
    
    // let durationLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(workout: Workout) {
        // Make a little UI for fun
        
        addSubview(containerView)
        containerView.edgeAnchors == edgeAnchors
        
        containerView.addSubview(workNameLabel)
        workNameLabel.heightAnchor == 24
        workNameLabel.numberOfLines = 1
        workNameLabel.textAlignment = .center
        workNameLabel.text = workout.name
        workNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        workNameLabel.topAnchor == topAnchor + 8
        workNameLabel.horizontalAnchors == horizontalAnchors
        
        containerView.addSubview(instructorImageView)
        instructorImageView.kf.setImage(with: URL(string: workout.instructor.avatarURL))
        instructorImageView.heightAnchor == 60
        instructorImageView.widthAnchor == 60
        instructorImageView.topAnchor == workNameLabel.bottomAnchor + 8
        instructorImageView.leftAnchor == leftAnchor + 8
        instructorImageView.bottomAnchor == bottomAnchor - 8
        
        containerView.addSubview(instructorNameLabel)
        instructorNameLabel.heightAnchor == 20
        instructorNameLabel.numberOfLines = 1
        instructorNameLabel.textAlignment = .left
        instructorNameLabel.text = workout.instructor.name
        instructorNameLabel.leftAnchor == instructorImageView.rightAnchor + 8
        instructorNameLabel.rightAnchor == rightAnchor
        instructorNameLabel.centerYAnchor == instructorImageView.centerYAnchor
        
        containerView.addSubview(idLabel)
        idLabel.heightAnchor == 16
        idLabel.font = UIFont.systemFont(ofSize: 8)
        idLabel.text = "\(workout.id)"
        idLabel.rightAnchor == containerView.rightAnchor - 8
        idLabel.bottomAnchor == containerView.bottomAnchor - 8
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func hide(){
        for aView in containerView.subviews{
            aView.alpha = 0.0
        }
    }
    
    func show(){
        for aView in containerView.subviews{
            aView.alpha = 1.0
        }
    }
}
