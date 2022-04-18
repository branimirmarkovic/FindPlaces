//
//  LoadMoreCell.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 14.4.22..
//

import Foundation
import UIKit


class LoadMoreCell: UICollectionViewCell {
    static let identifier = "load-more-cell"
    
    private let mainLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.text = "Load More"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(mainLabel)
    }
    
    private func configureLayout() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
}
