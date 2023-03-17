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
        cell?.placeNameTittle.text = viewModel?.title
        cell?.placeTypeTittle.text = viewModel?.type
        cell?.adressLabel.text = viewModel?.contact
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
         imageView.alpha = 0.3
        return imageView
    }()

     var placeNameTittle: UILabel = {
        let label = UILabel()
         label.font = UIFont.preferredFont(forTextStyle: .headline)
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

     var adressLabel: UILabel = {
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
        stack.spacing = 10
        return stack
    }()

    var textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        stack.distribution = .equalCentering
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
        bottomStack.addArrangedSubview(adressLabel)
        bottomStack.addArrangedSubview(UIView.horizontalSpacer())
        bottomStack.addArrangedSubview(driveTimeLabel)

        textStack.addArrangedSubview(placeNameTittle)
        textStack.addArrangedSubview(placeTypeTittle)
        textStack.addArrangedSubview(bottomStack)

        contentView.addSubview(placeImageView)
        contentView.addSubview(textStack)

    }

    private func configureLayout() {

        contentView.backgroundColor = ThemeProvider.main.backgroundColor
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        adressLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adressLabel.widthAnchor.constraint(equalToConstant: 150)
        ])

        textStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20),
            textStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -20),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
        ])

        placeImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            placeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            placeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            placeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            placeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        

    }


}
