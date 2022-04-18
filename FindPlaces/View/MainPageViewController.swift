//
//  MainPageViewController.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit
import GoogleMaps


class MainPageViewController: UIViewController {

    private let collectionView: UICollectionView
    private let googleMapView: GMSMapView
    private let viewModel: MainPageCompositeViewModel
    private let notificationService: NotificationService
    var tagCellPressed: ((TagViewModel) -> Void)?

    private var placeCells: [PlaceCellController] = []
    

    init(
        viewModel: MainPageCompositeViewModel,
        notificationService: NotificationService,
        layoutProvider: CollectionViewLayoutFactory,
        currentLocation: CLLocation
    ) {
        self.viewModel = viewModel
        self.notificationService = notificationService
        self.googleMapView = GMSMapView(
            frame: .zero,
            camera: GMSCameraPosition(
                latitude: currentLocation.coordinate.latitude,
                longitude: currentLocation.coordinate.longitude,
                zoom: 10))
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout:  layoutProvider.doubleSectionLayout())
        super.init(nibName: nil, bundle: nil)
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureLayout()
        configureCollectionView()
        configureGMView()
        bind()
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    private func configureGMView() {
        googleMapView.isMyLocationEnabled = true
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(googleMapView)
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        googleMapView.frame = view.frame
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])
        view.backgroundColor = .white

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
           for _ in 1...self.viewModel.placesCount {
               self.placeCells.append(PlaceCellController())
           }
           DispatchQueue.main.async {
               self.collectionView.reloadSections(IndexSet(integer: 1))
           }
       }
       
       viewModel.onTagsLoadStart = { [weak self] in
           guard let self = self else {return}
           DispatchQueue.main.async {
               self.notificationService.showSpinner(on: self.collectionView)
           }
       }
       
       viewModel.onTagsLoad = {[weak self] in
           guard let self = self else {return}
           DispatchQueue.main.async {
               self.collectionView.reloadSections(IndexSet(integer: 0))
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
}

extension MainPageViewController: UICollectionViewDataSource {

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
    // MARK: - Collection View Delegate Methods
extension MainPageViewController: UICollectionViewDelegate {
    
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
