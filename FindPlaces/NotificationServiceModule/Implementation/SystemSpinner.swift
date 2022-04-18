//
//  SystemSpinner.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 19.4.22..
//

import UIKit


class SystemSpinner: Spinner {

    private var spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        return spinner
    }()

    init () {}


    func stopAnimating() {
        spinnerView.stopAnimating()
        spinnerView.removeFromSuperview()
    }

    func startAnimating(on caller: UIView) {
        caller.addSubview(spinnerView)
        spinnerView.center = caller.center
        spinnerView.startAnimating()
    }
}
