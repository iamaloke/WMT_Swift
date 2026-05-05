//
//  ActivityIndictable.swift
//  WMT_Swift
//
//  Created by aloksingh on 04/04/26.
//

import UIKit

protocol ActivityIndicatable: AnyObject {
    func showActivity(message: String)
    func hideActivity()
}

private var activityIndicatorKey: UInt8 = 0

extension ActivityIndicatable where Self: UIViewController {
    
    private var activityIndicator: ActivityIndicator? {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorKey) as? ActivityIndicator
        }
        set {
            objc_setAssociatedObject(self, &activityIndicatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showActivity(message: String = "Loading...") {
        // Prevent duplicate
        if activityIndicator != nil { return }
        
        let indicator = loadFromNib()
        indicator.frame = view.bounds
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        indicator.initialize(message: message)
        
        view.addSubview(indicator)
        activityIndicator = indicator
    }
    
    func hideActivity() {
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
    
    // MARK: - Load from XIB
    private func loadFromNib() -> ActivityIndicator {
        let nib = UINib(nibName: "ActivityIndicator", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? ActivityIndicator else {
            fatalError("ActivityIndicator XIB not found")
        }
        return view
    }
}
