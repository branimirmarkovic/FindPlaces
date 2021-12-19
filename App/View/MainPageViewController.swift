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
        super.init(collectionViewLayout:  CollectionViewLayoutProvider.mainPageLayout())
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
        collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
    }

    private func loadData() {

        tagsViewModel.load()
        placesViewModel.load(type: "cuisine")
    }

    func bind() {
        placesViewModel.onLoad = { [weak self] places in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 1))
            }
        }

        placesViewModel.onError = { [weak self] message in
            guard let self = self else {return}
            self.notificationService.showDropdownNotification(message: message, on: self)
        }

        tagsViewModel.onLoad = {[weak self] tags in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }

        tagsViewModel.onError = { [weak self] message in
            guard let self = self else {return}
            self.notificationService.showDropdownNotification(message: message, on: self)

        }
    }

    // MARK: - Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tagsViewModel.tagsCount
        case 1 :
            return placesViewModel.placesCount
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return dequeueTagCell(collectionView, for: indexPath, tag: tagsViewModel.tag(at: indexPath.row))
        case 1:
            return dequeuePlaceCell(collectionView, for: indexPath, place: placesViewModel.place(at: indexPath.row))
        default :
            return UICollectionViewCell()
        }
    }

    private func dequeueTagCell(_ collectionView: UICollectionView, for indexPath: IndexPath, tag: TagViewModel?) -> TagCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell
        cell?.triposoTag = tag

        return cell ?? TagCollectionViewCell()
    }

    private func dequeuePlaceCell (_ collectionView: UICollectionView, for indexPath: IndexPath, place: PlaceViewModel?) -> PlaceCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCollectionViewCell.identifier, for: indexPath) as? PlaceCollectionViewCell
        cell?.place = place

        return cell ?? PlaceCollectionViewCell()
    }

    // MARK: - Collection View Delegate Methods

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedTagCell(collectionView, at: indexPath)
        case 1:
            selectedPlaceCell(collectionView, at: indexPath)
        default :
            ()
        }
    }

        private func selectedTagCell(_ collectionView: UICollectionView, at indexPath: IndexPath) {
            tagsViewModel.selectedTag(at: indexPath.row, placesViewModel: placesViewModel)

        }

    private func selectedPlaceCell(_ collectionView: UICollectionView, at indexPath: IndexPath) {

    }

}
