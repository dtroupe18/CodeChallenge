//
//  CircleImageView.swift
//  CodeChallenge
//
//  Created by Dave on 10/20/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor? {
        get {
            return layer.borderColor.map(UIColor.init)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    override var bounds: CGRect {
        didSet {
            round()
        }
    }
    
    override var frame: CGRect {
        didSet {
            round()
        }
    }
    
    init() {
        super.init(frame: .zero)
        round()
    }
    
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func round() {
        layer.cornerRadius = 0.5 * min(frame.width, frame.height)
        layer.masksToBounds = true
    }
}
