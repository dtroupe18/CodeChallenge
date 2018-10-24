//
//  LeaderboardCell.swift
//  CodeChallenge
//
//  Created by Dave on 10/24/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import Anchorage
import Kingfisher

class LeaderboardCell: UITableViewCell {
    
    let rankLabel = UILabel()
    let userImageView = CircleImageView()
    
    let middleStackView = UIStackView()
    let nameLabel = UILabel()
    let genderLocationLabel = UILabel()
    
    let rightStackView = UIStackView()
    let distanceLabel = UILabel()
    let heartRateLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with leaderboardUser: LeaderboardUser, rank: Int) {
        addSubview(rankLabel)
        rankLabel.leftAnchor == leftAnchor + 8
        rankLabel.centerYAnchor == centerYAnchor
        rankLabel.text = "#\(rank)"
        rankLabel.font = UIFont.boldSystemFont(ofSize: 18)
        rankLabel.textAlignment = .left
        rankLabel.widthAnchor == 50
        
        addSubview(userImageView)
        userImageView.kf.setImage(with: URL(string: leaderboardUser.user.avatarURL))
        userImageView.leftAnchor == rankLabel.rightAnchor + 8
        userImageView.topAnchor == topAnchor + 8
        userImageView.widthAnchor == 50
        userImageView.heightAnchor == 50
        userImageView.bottomAnchor == bottomAnchor - 8
        
        nameLabel.text = leaderboardUser.user.username.capitalized
        nameLabel.font = UIFont.boldSystemFont(ofSize: 12)
        nameLabel.textAlignment = .left
        
        genderLocationLabel.numberOfLines = 1
        genderLocationLabel.adjustsFontSizeToFitWidth = true
        genderLocationLabel.minimumScaleFactor = 0.4
        genderLocationLabel.font = UIFont.systemFont(ofSize: 10)
        
        genderLocationLabel.text = getGenderLocationString(user: leaderboardUser.user)
        genderLocationLabel.textAlignment = .left
        
        addSubview(middleStackView)
        addSubview(rightStackView)
        
        middleStackView.axis = .vertical
        middleStackView.addArrangedSubview(nameLabel)
        middleStackView.addArrangedSubview(genderLocationLabel)
        middleStackView.distribution = .fillEqually
        middleStackView.leftAnchor == userImageView.rightAnchor + 20
        middleStackView.rightAnchor == rightStackView.leftAnchor + 20
        middleStackView.centerYAnchor == userImageView.centerYAnchor
        
        distanceLabel.text = "0.0 Mi"
        distanceLabel.numberOfLines = 1
        distanceLabel.font = UIFont.boldSystemFont(ofSize: 12)
        distanceLabel.textAlignment = .left
        
        heartRateLabel.text = "0 BPM"
        heartRateLabel.numberOfLines = 1
        heartRateLabel.font = UIFont.boldSystemFont(ofSize: 12)
        heartRateLabel.textAlignment = .left
        
        rightStackView.axis = .vertical
        rightStackView.distribution = .fillEqually
        rightStackView.rightAnchor == rightAnchor - 8
        rightStackView.centerYAnchor == userImageView.centerYAnchor
        rightStackView.widthAnchor == 80
        rightStackView.addArrangedSubview(distanceLabel)
        rightStackView.addArrangedSubview(heartRateLabel)
    }
    
    func update(with metric: Metric, leaderboardUser: LeaderboardUser, rank: Int) {
        rankLabel.text = "#\(rank)"
        userImageView.kf.setImage(with: URL(string: leaderboardUser.user.avatarURL))
        nameLabel.text = leaderboardUser.user.username
        genderLocationLabel.text = "\(leaderboardUser.user.gender) / \(leaderboardUser.user.location)"
        distanceLabel.text = "distance: \(metric.distance)"
        if let heartRate = metric.heartRate {
            heartRateLabel.text = "\(heartRate)"
        }
    }
    
    func getGenderLocationString(user: User) -> String {
        var returnString = ""
        let gender = user.gender
        var rawLocation = user.location
        
        if gender != "" {
            returnString += gender
            returnString += " / "
        }
        
        if rawLocation == "" {
            rawLocation = "unknown"
        }
        
        var location = rawLocation.trimmingCharacters(in: .whitespacesAndNewlines)
        if let lastchar = location.last {
            if lastchar == "," {
                location = String(location.dropLast())
            }
        }
        returnString += location
        return returnString.uppercased()
    }
}
