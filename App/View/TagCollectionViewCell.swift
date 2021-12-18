//
//  TagCollectionViewCell.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {

    static let identifier = "tag-collection-view-cell"

    var badgeType: String?

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
        label.font = UIFont.preferredFont(forTextStyle: .title1)
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

    private func addSubviews() {

        let stackView: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                badgeImage,
                tagTitle,
                placesCountTitle
            ])
// TODO: - Stack config
            return stack
        }()

        badgeView.addSubview(stackView)

        self.contentView.addSubview(badgeView)
    }

    private func configureLayout() {
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        badgeImage.translatesAutoresizingMaskIntoConstraints = false
        tagTitle.translatesAutoresizingMaskIntoConstraints = false
        placesCountTitle.translatesAutoresizingMaskIntoConstraints = false
// TODO: - Make view square
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: contentView.topAnchor),
            badgeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            badgeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            badgeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }


}
