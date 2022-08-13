//
//  MainPageContainerViewController.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit
import UBottomSheet
import GoogleMaps


class MainPageContainerViewController: UIViewController {
    
    var tagCellPressed: ((TagViewModel) -> Void)?

    private let collectionView: PlacesCollectionViewController
    private let googleMapView: GMSMapView
    private let viewModel: MainPageCompositeViewModel
    private let notificationService: NotificationService
    private var placeCells: [PlaceCellController] = []
    
    init(
        viewModel: MainPageCompositeViewModel,
        notificationService: NotificationService,
        layoutProvider: CollectionViewLayoutFactory,
        currentLocation: CLLocation
    ) {
        self.viewModel = viewModel
        self.notificationService = notificationService
        self.googleMapView = GMSMapView(location: currentLocation, zoom: 10)
        self.collectionView = PlacesCollectionViewController(collectionViewLayout:  layoutProvider.doubleSectionLayout())
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {}
    
    
    private func bind() {
    
        viewModel.onPlacesLoadStart = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.notificationService.showSpinner(on: self.collectionView.collectionView)
            }
        }
        
        viewModel.onPlacesLoad = { [weak self] in
            guard let self = self else {return}
            self.placeCells = []
            for _ in 1...self.viewModel.placesCount {
                self.placeCells.append(PlaceCellController())
            }
            DispatchQueue.main.async {
                self.collectionView.collectionView.reloadSections(IndexSet(integer: 1))
            }
        }
        
        viewModel.onTagsLoadStart = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.notificationService.showSpinner(on: self.collectionView.collectionView)
            }
        }
        
        viewModel.onTagsLoad = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.collectionView.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
        
        viewModel.onCompleteLoad = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.notificationService.stopSpinner()
            }
        }
        
        viewModel.onError = { [weak self] message in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.notificationService.stopSpinner()
                self.notificationService.showDropdownNotification(message: message)
            }
        }
     }
    
    
    
    private func configureUI() {
        addSubviews()
        configureLayout()
        configureCollectionView()
        displayCollectionView()
        configureGMView()
    }
    
    private func addSubviews() {
        view.addSubview(googleMapView)
    }
    
    private func configureLayout() {
        
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            googleMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            googleMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            googleMapView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        view.backgroundColor = .white
        
    }
    
    private func configureGMView() {
        googleMapView.isMyLocationEnabled = true
    }
    
    private func displayCollectionView() {
        let sheetCoordinator = UBottomSheetCoordinator(parent: self)
        collectionView.sheetCoordinator = sheetCoordinator
        sheetCoordinator.addSheet(collectionView, to: self)	
    }

    private func configureCollectionView() {
        collectionView.collectionView.dataSource = self
        collectionView.collectionView.delegate = self
        collectionView.collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        collectionView.collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.collectionView.backgroundColor = .white
    }
}

     // MARK: - Collection View Data Source
extension MainPageContainerViewController: UICollectionViewDataSource {

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.tagsCount
        case 1 :
            return viewModel.placesCount
        default:
            return 0
        }
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return dequeueTagCell(collectionView, for: indexPath, tag: viewModel.tag(at: indexPath.row))
        case 1:
            return placeCells[indexPath.row].dequeueCell(collectionView, for: indexPath, place: viewModel.place(at: indexPath.row))
        default :
            return UICollectionViewCell()
        }
    }

    private func dequeueTagCell(_ collectionView: UICollectionView, for indexPath: IndexPath, tag: TagViewModel?) -> TagCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.identifier, for: indexPath) as? TagCollectionViewCell
        cell?.triposoTag = tag

        return cell ?? TagCollectionViewCell()
    }
    
    private func dequeueLoadMoreCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> LoadMoreCell? {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCell.identifier, for: indexPath) as? LoadMoreCell
        return cell 
    }

    
}
    // MARK: - Collection View Delegate
extension MainPageContainerViewController: UICollectionViewDelegate {
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
            guard let selectedTag = viewModel.tag(at: indexPath.row) else {return}
            tagCellPressed?(selectedTag)
        }

    private func selectedPlaceCell(_ collectionView: UICollectionView, at indexPath: IndexPath) {
// TODO: - Display place details
    }

}