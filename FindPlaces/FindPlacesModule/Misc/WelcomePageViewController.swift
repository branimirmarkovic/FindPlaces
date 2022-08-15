//
//  WelcomePageViewController.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 15.8.22..
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    
    let mascotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mascot")
        return imageView
        
    }()
    
    let errorTittleLabel: UILabel = {
       let label = UILabel()
        label.text = "Welcome"
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = .white
        
    }
    
    private func configureUI() {
        addSubviews()
        configureLayout()
    }
    
    private func addSubviews() {
        view.addSubview(mascotImageView)
        view.addSubview(errorTittleLabel)
    }
    
    private func configureLayout() {
        
        mascotImageView.translatesAutoresizingMaskIntoConstraints = false 
        NSLayoutConstraint.activate([
            mascotImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            mascotImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.3),
            mascotImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            mascotImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        errorTittleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorTittleLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            errorTittleLabel.heightAnchor.constraint(equalToConstant: 50),
            errorTittleLabel.topAnchor.constraint(equalTo: mascotImageView.bottomAnchor, constant: 10),
            errorTittleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
    }
    
}
