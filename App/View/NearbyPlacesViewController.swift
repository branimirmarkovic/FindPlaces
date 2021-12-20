//
//  NearbyPlacesViewController.swift
//  App
//
//  Created by Branimir Markovic on 20.12.21..
//

import Foundation
import UIKit
import GoogleMaps
import GoogleMapsCore
import GoogleMapsM4B

class NearbyPlacesViewController: UIViewController {

    private var placesCollectionView: UICollectionView
    private var googleMapView: GMSMapView

    private var placesViewModel: PlacesViewModel
    private var notificationService: NotificationService
    private var selectedTagViewModel: TagViewModel


    init(placesViewModel: PlacesViewModel, notificationService: NotificationService,selectedTagViewModel:TagViewModel) {
        self.placesViewModel = placesViewModel
        self.notificationService = notificationService
        self.selectedTagViewModel = selectedTagViewModel
        self.placesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewLayoutProvider.placesPageLayout())
        self.googleMapView = GMSMapView()
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
        configureNavigationBar()
        bind()
        loadData()
    }

    private func loadData() {
        placesViewModel.load(type: selectedTagViewModel.tagSearchLabel)
    }

    private func bind() {
        func bind() {
            placesViewModel.onLoad = { [weak self]  in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.placesCollectionView.reloadData()
                }
            }

            placesViewModel.onError = { [weak self] message in
                guard let self = self else {return}
                self.notificationService.showDropdownNotification(message: message, on: self)
            }
        }
    }

    private func configureLayout() {
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            googleMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            googleMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            googleMapView.heightAnchor.constraint(equalToConstant: view.bounds.height/2)
        ])
        placesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placesCollectionView.topAnchor.constraint(equalTo: googleMapView.bottomAnchor),
            placesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            placesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

    }

    private func addSubviews() {
        view.addSubview(googleMapView)
        view.addSubview(placesCollectionView)

    }

    private func configureCollectionView() {
        placesCollectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        placesCollectionView.delegate = self
        placesCollectionView.dataSource = self
    }

    private func configureGMView() {
    }

    private func configureNavigationBar() {
        self.navigationItem.title = selectedTagViewModel.name
    }

}

extension NearbyPlacesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        placesViewModel.placesCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dequeuePlaceCell(collectionView, for: indexPath, place: placesViewModel.place(at: indexPath.row))
    }

    private func dequeuePlaceCell (_ collectionView: UICollectionView, for indexPath: IndexPath, place: PlaceViewModel?) -> PlaceCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceCollectionViewCell.identifier, for: indexPath) as? PlaceCollectionViewCell
        cell?.place = place

        return cell ?? PlaceCollectionViewCell()
    }


}
