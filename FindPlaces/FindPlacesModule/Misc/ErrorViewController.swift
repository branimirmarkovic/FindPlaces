//
//  ErrorViewController.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 13.4.22..
//

import Foundation
import UIKit

class ErrorViewController: UIViewController {
    
    
    let mascotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mascot")
        return imageView
        
    }()
    
    let errorTittleLabel: UILabel = {
       let label = UILabel()
        label.text = "Sorry :("
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
         label.textAlignment = .center
         label.font = UIFont.preferredFont(forTextStyle: .body)
         label.textColor = .black
         return label
     }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ThemeProvider.main.mainColor
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.isHidden = true
        return button
    }()
    
    private let buttonTappedAction: (() -> Void)?
    private let buttonTittle: String?
    private let message: String
    
    init(message: String?, buttonTittle: String?, buttonTappedAction: (() -> Void)?) {
        self.message = message ?? "Something went wrong..."
        self.buttonTappedAction = buttonTappedAction
        self.buttonTittle = buttonTittle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        view.backgroundColor = .white
    }
    
    private func configureUI() {
        addSubviews()
        configureLayout()
        bind()
        
    }
    
    private func addSubviews() {
        view.addSubview(mascotImageView)
        view.addSubview(errorTittleLabel)
        view.addSubview(errorMessageLabel)
        view.addSubview(actionButton)
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
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorMessageLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            errorMessageLabel.heightAnchor.constraint(equalToConstant: 50),
            errorMessageLabel.topAnchor.constraint(equalTo: errorTittleLabel.bottomAnchor, constant: 10),
            errorMessageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            actionButton.heightAnchor.constraint(equalToConstant: 30),
            actionButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 10),
            actionButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
    }
    
    private func bind() {
        errorMessageLabel.text = message
        if buttonTappedAction != nil {
            let buttonAction = UIAction { _ in
                self.buttonTappedAction?()
            }
            actionButton.addAction(buttonAction, for: .touchUpInside)
            actionButton.setTitle(buttonTittle, for: .normal)
            actionButton.isHidden = false
        }
    }
    
    
    
    
}
