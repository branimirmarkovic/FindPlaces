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
        loadData()
    }

    private func configureCollectionView() {
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
    }

    private func loadData() {
        notificationService.startSpinner()
        tagsViewModel.load()
    }

    func bind() {
        placesViewModel.onLoad = { [weak self] places in
            guard let self = self else {return}
            self.notificationService.stopSpinner()

        }

        placesViewModel.onError = { [weak self] message in
            guard let self = self else {return}
            self.notificationService.stopSpinner()
            self.notificationService.showDropdownNotification(message: message, on: self)
        }

        tagsViewModel.onLoad = {[weak self] tags in
            guard let self = self else {return}
            self.notificationService.stopSpinner()

        }

        tagsViewModel.onError = { [weak self] message in
            guard let self = self else {return}
            self.notificationService.stopSpinner()
            self.notificationService.showDropdownNotification(message: message, on: self)

        }
    }

    // MARK: - Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
}
