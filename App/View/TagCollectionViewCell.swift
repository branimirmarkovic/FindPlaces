//
//  TagCollectionViewCell.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    static let identifier = "tag-collection-view-cell"

    var triposoTag: TagViewModel? {
        didSet {
            bind()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var badgeView: UIView  = {
        let view = UIView()
        view.backgroundColor = ThemeProvider.main.tintColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 30
        return view
    }()

    private var badgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var tagTitle: UILabel = {
        let label = UILabel()
        label.textColor = ThemeProvider.main.backgroundColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private var placesCountTitle: UILabel = {
        let label = UILabel()
        label.textColor = ThemeProvider.main.backgroundColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 30
        return stack
    }()

    private func addSubviews() {
        stackView.addArrangedSubview(badgeImage)
        stackView.addArrangedSubview(tagTitle)
        stackView.addArrangedSubview(placesCountTitle)
        badgeView.addSubview(stackView)
        contentView.addSubview(badgeView)
    }

    private func configureLayout() {

        badgeView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
            ])
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            badgeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            badgeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            badgeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func bind() {
        self.tagTitle.text = triposoTag?.name
        self.placesCountTitle.text = triposoTag?.numberOfLocations
    }




}
