//
//  MainPageViewController.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit


class MainPageViewController: UICollectionViewController {

    private var placesViewModel: PlacesViewModel
    private var tagsViewModel: TagsViewModel

    init(placesViewModel: PlacesViewModel, tagsViewModel: TagsViewModel) {
        self.placesViewModel = placesViewModel
        self.tagsViewModel = tagsViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }

    private func configureCollectionView() {
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
    }

    func bind() {
        placesViewModel.onLoad = { places in

        }

        placesViewModel.onError = { error in

        }

        tagsViewModel.onLoad = { tags in

        }

        tagsViewModel.onError = { error in

        }
    }

    // MARK: - Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
}
