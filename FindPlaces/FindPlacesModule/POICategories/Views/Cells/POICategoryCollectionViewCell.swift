//
//  POICollectionViewCell.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import UIKit

class POICategoryCollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "poi-collection-view-header"
    
    var poiViewModel: PointOfInterestCategoryViewModel? {
        didSet {
            bind()
        }
    }
    
    private var selectionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
        configureActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var badgeButtonView: UIButton  = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = ThemeProvider.main.backgroundColor
        button.titleLabel?.textColor = ThemeProvider.main.tintColor
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return button
    }()

    private func addSubviews() {
        addSubview(badgeButtonView)
    }

    private func configureLayout() {
        
        let contentOffset: CGFloat = 20

        badgeButtonView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            badgeButtonView.topAnchor.constraint(equalTo: topAnchor),
            badgeButtonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            badgeButtonView.bottomAnchor.constraint(equalTo: bottomAnchor),
            badgeButtonView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        self.heightConstraint =  self.heightAnchor.constraint(equalToConstant: 0)
    }
    
    private func configureActions() {
        let action = UIAction {[weak self] action in 
            self?.selectionHandler?()
        }
        badgeButtonView.addAction(action, for: .touchUpInside)
    }
    
    private var heightConstraint: NSLayoutConstraint?

    private func bind() {
        if let viewModel = poiViewModel {
            self.selectionHandler =  {
                viewModel.selectionHandler?()
            }
            badgeButtonView.setTitle(viewModel.name, for: .normal)
            badgeButtonView.backgroundColor = ThemeProvider.main.tintColor
            badgeButtonView.titleLabel?.textColor = ThemeProvider.main.backgroundColor
            heightConstraint?.isActive = false
        } else {
            heightConstraint?.isActive = true
        }
    }

    
}

class POICategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = "poi-collection-view-cell"

    var poiViewModel: PointOfInterestCategoryViewModel? {
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
        view.backgroundColor = ThemeProvider.main.backgroundColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()

    private var badgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var categoryTitle: UILabel = {
        let label = UILabel()
        label.textColor = ThemeProvider.main.tintColor
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    private func addSubviews() {
        stackView.addArrangedSubview(badgeImage)
        stackView.addArrangedSubview(categoryTitle)
        badgeView.addSubview(stackView)
        contentView.addSubview(badgeView)
    }

    private func configureLayout() {
        
        let contentOffset: CGFloat = 20

        badgeView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            categoryTitle.centerXAnchor.constraint(equalTo: badgeView.centerXAnchor),
            categoryTitle.widthAnchor.constraint(equalTo: badgeView.widthAnchor, constant: -contentOffset),
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
        guard let poiViewModel = poiViewModel else {return}
        self.categoryTitle.text = poiViewModel.name
        if poiViewModel.isSelected {
            badgeView.backgroundColor = ThemeProvider.main.tintColor
            categoryTitle.textColor = ThemeProvider.main.backgroundColor
        } else {
            badgeView.backgroundColor = ThemeProvider.main.backgroundColor
            categoryTitle.textColor = ThemeProvider.main.tintColor
        }
    }




}
