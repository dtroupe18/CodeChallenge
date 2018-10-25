//
//  Double+Extension.swift
//  CodeChallenge
//
//  Created by Dave on 10/24/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import Foundation

extension Double {
    var roundedTwoDecimalString: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self))
    }
    
    var roundedThreeDecimalString: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.roundingMode = NumberFormatter.RoundingMode.halfUp
        formatter.maximumFractionDigits = 3
        return formatter.string(from: NSNumber(value: self))
    }
    
    var intValue: Int {
        return Int(self)
    }
    
    var distanceString: String? {
        if let rounded = self.roundedThreeDecimalString {
            return "\(rounded) Mi"
        } else {
           return nil
        }
    }
}
