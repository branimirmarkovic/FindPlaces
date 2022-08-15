//
//  PointOfInterestExpandButton.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 15.8.22..
//

import UIKit

class PointOfInterestExpandButton: UIButton {
    
    var buttonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(action: (()-> Void)?) {
        self.init(frame: .zero)
        self.buttonAction = buttonAction
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        var config = UIButton.Configuration.filled()
        config.image =  UIImage(systemName: "line.3.horizontal")
        config.imagePlacement = .all
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .large)
        config.cornerStyle = .medium
        self.configuration = config
        let action = UIAction { action in
            self.buttonAction?()
        }
        self.addAction(action, for: .touchUpInside)
        self.configuration = config
    }
    
    

    
   
    
}
