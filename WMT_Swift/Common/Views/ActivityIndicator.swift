//
//  ActivityIndicator.swift
//  WMT_Swift
//
//  Created by aloksingh on 23/03/26.
//

import UIKit

final class ActivityIndicator: UIView {

    @IBOutlet private weak var wrapperView: UIView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var messageLbl: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        wrapperView.layer.cornerRadius = 10.0
    }
    
    func initialize(message: String) {
        messageLbl.text = message
        indicatorView.startAnimating()
    }
    
    func stop() {
        indicatorView.stopAnimating()
    }
}
