//
//  PlaceCollectionViewCell.swift
//  App
//
//  Created by Branimir Markovic on 19.12.21..
//

import Foundation
import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {

    static let identifier = "place-collection-view-cell"

    var place: PlaceViewModel? {
        didSet {
            bind()
        }
    }

    private var placeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "DefaultPlaceImage")
        return imageView
    }()

    private var placeNameTittle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private var placeTypeTittle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private var driveTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label

    }()

    private var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 30
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    private var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        stack.distribution = .fillEqually
        stack.alignment = .leading
        return stack
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
        bottomStack.addArrangedSubview(scoreLabel)
        bottomStack.addArrangedSubview(priceLabel)
        bottomStack.addArrangedSubview(driveTimeLabel)

        mainStack.addArrangedSubview(placeNameTittle)
        mainStack.addArrangedSubview(placeTypeTittle)
        mainStack.addArrangedSubview(bottomStack)

        contentView.addSubview(mainStack)
        contentView.addSubview(placeImageView)

    }

    private func configureLayout() {

        contentView.backgroundColor = ThemeProvider.main.backgroundColor
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true

        bottomStack.translatesAutoresizingMaskIntoConstraints = false


        placeImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            placeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            placeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            placeImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor)
        ])

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: placeImageView.trailingAnchor, constant: 20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10)
        ])

    }

   private func bind() {
       placeNameTittle.text = place?.tittle
       placeTypeTittle.text = place?.type
       scoreLabel.text = place?.rating()
       priceLabel.text = place?.price()
       driveTimeLabel.text = place?.distance()
    }
}
