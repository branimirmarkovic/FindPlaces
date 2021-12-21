//
//  PlaceCollectionViewCell.swift
//  App
//
//  Created by Branimir Markovic on 19.12.21..
//

import Foundation
import UIKit

class PlaceCellController {

    var cell: PlaceCollectionViewCell?

    var viewModel: PlaceViewModel? {
        didSet {
            bindViewModel()
        }
    }

    var image: UIImage? {
        didSet{
            DispatchQueue.main.async {
                self.cell?.placeImageView.image = self.image
            }
        }
    }


    private func bindViewModel() {

        viewModel?.onImageLoad = {[weak self] imageData in
            guard let image = UIImage(data: imageData) else {return}
            self?.image = image
        }
        viewModel?.onError = { [weak self] in

        }
        cell?.placeNameTittle.text = viewModel?.tittle
        cell?.placeTypeTittle.text = viewModel?.type
        cell?.scoreLabel.text = viewModel?.rating()
        cell?.priceLabel.text = viewModel?.price()
        cell?.driveTimeLabel.text = viewModel?.distance()
     }

     func dequeueCell (_ collectionView: UICollectionView, for indexPath: IndexPath, place: PlaceViewModel?) -> PlaceCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCollectionViewCell.identifier, for: indexPath) as? PlaceCollectionViewCell
        self.cell = cell
        self.viewModel = place
        if self.image == nil {
            self.viewModel?.loadImage()
        }
        return cell ?? PlaceCollectionViewCell()
    }
}

class PlaceCollectionViewCell: UICollectionViewCell {

    static let identifier = "place-collection-view-cell"



     var placeImageView: UIImageView = {
        let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "DefaultPlaceImage")
        return imageView
    }()

     var placeNameTittle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

     var placeTypeTittle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

     var scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

     var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

     var driveTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label

    }()

     var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 30
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()

    var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        stack.distribution = .equalCentering
        stack.alignment = .leading
        return stack
    }()

     var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        
        stack.distribution = .fillEqually
        stack.alignment = .center
         stack.spacing = 20
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

        textStack.addArrangedSubview(placeNameTittle)
        textStack.addArrangedSubview(placeTypeTittle)
        textStack.addArrangedSubview(bottomStack)

        mainStack.addArrangedSubview(placeImageView)
        mainStack.addArrangedSubview(textStack)

        contentView.addSubview(mainStack)

    }

    private func configureLayout() {

        contentView.backgroundColor = ThemeProvider.main.backgroundColor
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20)
        ])

    }


}
