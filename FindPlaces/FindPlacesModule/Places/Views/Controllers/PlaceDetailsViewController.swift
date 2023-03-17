//
//  PlaceDetailsViewController.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit


class PlaceDetailsViewController: UIViewController {

    private var placeViewModel: PlaceViewModel
    
    private var placeImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
       imageView.image = UIImage(named: "DefaultPlaceImage")
       return imageView
   }()

    private var placeNameTittle: UILabel = {
       let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
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

    private var textStack: UIStackView = {
       let stack = UIStackView()
       stack.axis = .vertical

       stack.distribution = .equalCentering
       stack.alignment = .leading
       return stack
   }()

   
    init(viewModel: PlaceViewModel) {
        self.placeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        bind()
        placeViewModel.loadImage(quality: .best)
    }
    
    private func bind() {
        
        placeViewModel.onImageLoad = {[weak self] imageData in
            guard let image = UIImage(data: imageData) else {return}
            DispatchQueue.main.async {
                self?.placeImageView.image = image
            }
        }
        placeViewModel.onError = {}
        
        placeNameTittle.text = placeViewModel.title
        placeTypeTittle.text = placeViewModel.type
        scoreLabel.text = placeViewModel.contact
        priceLabel.text = placeViewModel.address
        driveTimeLabel.text = placeViewModel.distance()
    }
   

   private func addSubviews() {
       bottomStack.addArrangedSubview(scoreLabel)
       bottomStack.addArrangedSubview(priceLabel)
       bottomStack.addArrangedSubview(driveTimeLabel)

       textStack.addArrangedSubview(placeNameTittle)
       textStack.addArrangedSubview(placeTypeTittle)
       textStack.addArrangedSubview(bottomStack)

       view.addSubview(placeImageView)
       view.addSubview(textStack)

   }

   private func configureLayout() {

       view.backgroundColor = ThemeProvider.main.backgroundColor

       

       placeImageView.translatesAutoresizingMaskIntoConstraints = false

       NSLayoutConstraint.activate([
           placeImageView.topAnchor.constraint(equalTo: view.topAnchor),
           placeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           placeImageView.heightAnchor.constraint(equalToConstant: view.frame.height/2),
           placeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
       ])
       
       textStack.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           textStack.topAnchor.constraint(equalTo: placeImageView.bottomAnchor,constant: 20),
           textStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
           textStack.heightAnchor.constraint(equalToConstant: 50),
           textStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
       ])
       

   }

    
}
