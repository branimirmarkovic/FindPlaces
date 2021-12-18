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
    private var notificationService: NotificationService

    init(placesViewModel: PlacesViewModel, tagsViewModel: TagsViewModel, notificationService: NotificationService) {
        self.placesViewModel = placesViewModel
        self.tagsViewModel = tagsViewModel
        self.notificationService = notificationService
        super.init(collectionViewLayout: UICollectionViewLayout.init())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
        tagsViewModel.load()
    }

    private func configureCollectionView() {
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
    }

    func bind() {
        placesViewModel.onLoad = { [weak self] places in
            guard let _ = self else {return}

        }

        placesViewModel.onError = { [weak self] error in
            guard let self = self else {return}
            self.notificationService.showDropdownNotification(message: error.localizedDescription, caller: self)
        }

        tagsViewModel.onLoad = {[weak self] tags in
            guard let _ = self else {return}

        }

        tagsViewModel.onError = { [weak self] error in
            guard let self = self else {return}
            self.notificationService.showDropdownNotification(message: error.localizedDescription, caller: self)

        }
    }

    // MARK: - Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
}
