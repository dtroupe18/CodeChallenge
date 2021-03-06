//
//  CustomActivityIndicator.swift
//  AnatomyShare
//
//  Created by Dave on 1/12/18.
//  Copyright © 2018 Dave. All rights reserved.
//

import UIKit

class CustomActivityIndicator {
    
    // We need to make this a singleton in order for
    // the same views to be added and removed each time
    //
    static let shared = CustomActivityIndicator()
    
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var label: UILabel = UILabel()
    
    // Show customized activity indicator,
    // actually add activity indicator to passing view
    // @param uiView - add activity indicator to this view
    //
    func show(uiView: UIView) {
        uiView.isUserInteractionEnabled = false
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.6)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        activityIndicator.hidesWhenStopped = true
        
        DispatchQueue.main.async {
            self.loadingView.addSubview(self.activityIndicator)
            uiView.addSubview(self.loadingView)
            self.activityIndicator.startAnimating()
        }
    }
    
    // Show customized activity indicator,
    // actually add activity indicator to passing view
    // @param uiView - add activity indicator to this view
    // @param color (optional) - color for the background of the activity indicator
    //
    func show(uiView: UIView, color: UIColor?) {
        uiView.isUserInteractionEnabled = false
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = color ?? UIColor.darkGray.withAlphaComponent(0.6)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        activityIndicator.hidesWhenStopped = true
        
        DispatchQueue.main.async {
            self.loadingView.addSubview(self.activityIndicator)
            uiView.addSubview(self.loadingView)
            self.activityIndicator.startAnimating()
        }
    }
    
    // Show customized activity indicator,
    // actually add activity indicator to passing view
    // @param uiView - add activity indicator to this view
    // @param color - color for the background of the activity indicator
    // @param size - desired size of the activity indicator
    //
    func show(uiView: UIView, color: UIColor?, size: Double) {
        uiView.isUserInteractionEnabled = false
        loadingView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        loadingView.center = uiView.center
        loadingView.backgroundColor = color ?? UIColor.darkGray.withAlphaComponent(0.6)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: size / 2, height: size / 2)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        activityIndicator.hidesWhenStopped = true
        
        DispatchQueue.main.async {
            self.loadingView.addSubview(self.activityIndicator)
            uiView.addSubview(self.loadingView)
            self.activityIndicator.startAnimating()
        }
    }
    
    // Hide activity indicator
    // Actually remove activity indicator from its super view
    // @param uiView - remove activity indicator from this view
    //
    func hide(uiView: UIView) {
        // check to make sure container is a subview before we
        // remove it
        if loadingView.isDescendant(of: uiView) {
            DispatchQueue.main.async {
                uiView.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    // Hide activity indicator
    // Actually remove activity indicator from its super view
    // @param uiView - remove activity indicator from this view
    // @param delay - milliseconds to delay the removal of the activity indicator
    //
    func hide(uiView: UIView, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.loadingView.isDescendant(of: uiView) {
                uiView.isUserInteractionEnabled = true
                self.activityIndicator.stopAnimating()
                self.loadingView.removeFromSuperview()
            }
        }
    }
}

// In order to show the activity indicator, call the function from your view controller
// CustomActivityIndicator.sharedInstance.showActivityIndicator(uiView: self.view)

// In order to hide the activity indicator, call the function from your view controller
// CustomActivityIndicator.sharedInstance.hideActivityIndicator(uiView: self.view)




