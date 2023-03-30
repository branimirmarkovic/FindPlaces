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
        viewModel?.onError = { 

        }
        cell?.placeNameTittle.text = viewModel?.title
        cell?.placeTypeTittle.text = viewModel?.type
        cell?.phoneContactLabel.text = viewModel?.contact
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

     var phoneContactLabel: UILabel = {
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
        bottomStack.addArrangedSubview(phoneContactLabel)
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
        
        phoneContactLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            phoneContactLabel.widthAnchor.constraint(equalToConstant: 150)
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

final class NoPlaceResultsCell: UICollectionViewCell {
    
    static let identifier = "no-place-results-collection-view-cell"
    
    let mascotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Mascot")
        imageView.contentMode = .scaleAspectFit
        return imageView
        
    }()
    
    let errorTittleLabel: UILabel = {
       let label = UILabel()
        label.text = "No results."
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    private func addSubviews() {
        
        addSubview(mascotImageView)
        addSubview(errorTittleLabel)
    }
    
    private func configureLayout() {
        
        mascotImageView.translatesAutoresizingMaskIntoConstraints = false 
        NSLayoutConstraint.activate([
            mascotImageView.widthAnchor.constraint(equalToConstant: 150),
            mascotImageView.heightAnchor.constraint(equalToConstant: 150),
            mascotImageView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            mascotImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])
        
        errorTittleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorTittleLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            errorTittleLabel.heightAnchor.constraint(equalToConstant: 50),
            errorTittleLabel.topAnchor.constraint(equalTo: mascotImageView.bottomAnchor, constant: 10),
            errorTittleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
        
    }
    
}

final class EmptyCell: UICollectionViewCell {
    static let identifier = "empty-cell"
}
