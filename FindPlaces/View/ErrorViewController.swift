//
//  ErrorViewController.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 13.4.22..
//

import Foundation
import UIKit

class ErrorViewController: UIViewController {
    
    let errorLabel: UILabel = {
       let label = UILabel()
        label.text = "Please Provide Location Permission!"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(errorLabel)
        configureLayout()
        
        view.backgroundColor = .white
    }
    
    private func configureLayout() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            errorLabel.heightAnchor.constraint(equalToConstant: 50),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    
    
}
