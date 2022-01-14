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

    private var placeCells: [PlaceCellController] = []


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
        placesViewModel.load(type: selectedTagViewModel.tagSearchLabel,orderBy: .distance)
    }

    private func bind() {
        placesViewModel.onLoad = { [weak self]  in
            guard let self = self else {return}
            self.createCellControllers()
            DispatchQueue.main.async {
                self.placesCollectionView.reloadData()
            }
        }

        placesViewModel.onError = { [weak self] message in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.notificationService.showDropdownNotification(message: message)
            }
        }

        placesViewModel.onObtainingLocation = { [weak self] location in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.configureGMCamera(with: location)
                self.placeMarkers(for: self.placesViewModel.allPlaces())
            }
        }

    }

    private func addSubviews() {
        view.addSubview(googleMapView)
        view.addSubview(placesCollectionView)

    }

    private func configureLayout() {
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleMapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            googleMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            googleMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            googleMapView.heightAnchor.constraint(equalToConstant: view.bounds.height * 1/3)
        ])
        placesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placesCollectionView.topAnchor.constraint(equalTo: googleMapView.bottomAnchor),
            placesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            placesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        view.backgroundColor = .white

    }

    private func configureCollectionView() {
        placesCollectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        placesCollectionView.delegate = self
        placesCollectionView.dataSource = self
        placesCollectionView.backgroundColor = .white
        createCellControllers()
    }

    private func configureNavigationBar() {
        self.navigationItem.title = selectedTagViewModel.name
    }

    private func createCellControllers() {
        self.placeCells = []
        self.placesViewModel.allPlaces().forEach { _ in
            self.placeCells.append(PlaceCellController())
        }
    }

    private func configureGMView() {
        googleMapView.isMyLocationEnabled = true
    }

    private func placeMarkers(for places: [PlaceViewModel]) {
        places.forEach({createMarker(for: $0)})
    }

    private func createMarker(for place: PlaceViewModel) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        marker.title = place.tittle
        marker.map = googleMapView
    }

    private func zoom(to location: CLLocation) {
        googleMapView.animate(toLocation: location.coordinate)
        googleMapView.animate(toZoom: 17)
    }

    private func configureGMCamera(with location: CLLocation) {
        self.googleMapView.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15))

    }

}

extension NearbyPlacesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        placesViewModel.placesCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return placeCells[indexPath.row].dequeueCell(collectionView, for: indexPath, place: placesViewModel.place(at: indexPath.row))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let place = placesViewModel.place(at: indexPath.row) else {return}
        let location = CLLocation(latitude: place.latitude, longitude: place.longitude)
        zoom(to: location)
    }


}
