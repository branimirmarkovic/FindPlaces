//
//  MainPageViewController.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit


class MainPageViewController: UICollectionViewController {

    private let viewModel: MainPageCompositeViewModel
    private var notificationService: NotificationService

    private var placeCells: [PlaceCellController] = []

    init(viewModel: MainPageCompositeViewModel, notificationService: NotificationService) {
        self.viewModel = viewModel
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
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    private func configureCollectionView() {
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
    }

   private func bind() {

       viewModel.onPlacesLoadStart = { [weak self] in
           guard let self = self else {return}
           DispatchQueue.main.async {
               self.notificationService.showSpinner(on: self.collectionView)
           }
       }

        viewModel.onPlacesLoad = { [weak self] in
            guard let self = self else {return}
            self.placeCells = []
            for _ in 1...self.viewModel.placesViewModel.placesCount {
                self.placeCells.append(PlaceCellController())
            }
            DispatchQueue.main.async {
                self.notificationService.stopSpinner()
                self.collectionView.reloadSections(IndexSet(integer: 1))
            }
        }

       viewModel.onTagsLoadStart = { [weak self] in
           guard let self = self else {return}

       }

        viewModel.onTagsLoad = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }

       viewModel.onError = { [weak self] message in
           guard let self = self else {return}
           DispatchQueue.main.async {
           self.notificationService.showDropdownNotification(message: message)
           }
       }


    }

    // MARK: - Data Source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.tagsViewModel.tagsCount
        case 1 :
            return viewModel.placesViewModel.placesCount
        default:
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return dequeueTagCell(collectionView, for: indexPath, tag: viewModel.tagsViewModel.tag(at: indexPath.row))
        case 1:
            return placeCells[indexPath.row].dequeueCell(collectionView, for: indexPath, place: viewModel.placesViewModel.place(at: indexPath.row))
        default :
            return UICollectionViewCell()
        }
    }

    private func dequeueTagCell(_ collectionView: UICollectionView, for indexPath: IndexPath, tag: TagViewModel?) -> TagCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell
        cell?.triposoTag = tag

        return cell ?? TagCollectionViewCell()
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
            guard let selectedTag = viewModel.tagsViewModel.tag(at: indexPath.row) else {return}
            let placesViewController = UIComposer.nearbyPlacesViewController(viewModel: self.viewModel.placesViewModel, notificationService: self.notificationService, selectedTagViewModel: selectedTag)
            navigationController?.pushViewController(placesViewController, animated: true)
        }

    private func selectedPlaceCell(_ collectionView: UICollectionView, at indexPath: IndexPath) {
// TODO: - Display place details
    }

}
