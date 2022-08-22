//
//  MainPageContainerViewController.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit
import GoogleMaps


class MainPageContainerViewController: UIViewController {
    
    var singlePLaceControllerPresentationHandler: ((PlaceViewModel) -> Void)?
    
    private let collectionView: PlacesCollectionViewController
    private let googleMapView: GMSMapView
    private let viewModel: MainPageCompositeViewModel
    private let notificationService: NotificationService
    private var placeCells: [PlaceCellController] = []
    private let poiButton: PointOfInterestExpandButton = PointOfInterestExpandButton(action: nil)
    
    init(
        viewModel: MainPageCompositeViewModel,
        notificationService: NotificationService,
        layoutProvider: CollectionViewLayoutFactory,
        currentLocation: CLLocation
    ) {
        self.viewModel = viewModel
        self.notificationService = notificationService
        self.googleMapView = GMSMapView(location: currentLocation, zoom: 14)
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
            if self.viewModel.placesCount > 0 {
                for _ in 1...self.viewModel.placesCount {
                    self.placeCells.append(PlaceCellController())
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.collectionView.reloadSections(IndexSet(integer: 1))
                self.notificationService.stopSpinner()
                self.placeMarkers(for: self.viewModel.allPlaces())
            }
        }
        
        viewModel.onPlaceSelection = { placeViewModel in 
            if let placeViewModel = placeViewModel {
                if let presentedViewController = self.presentedViewController {
                    presentedViewController.dismiss(animated: true) {
                        self.singlePLaceControllerPresentationHandler?(placeViewModel)
                    }
                } else {
                    self.singlePLaceControllerPresentationHandler?(placeViewModel)
                }
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
        
        viewModel.onTagSelection = {[weak self] in
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
        configureExpandButton()
    }
    
    private func addSubviews() {
        view.addSubview(googleMapView)
        view.addSubview(poiButton)
    }
    
    private func configureLayout() {
        
        googleMapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            googleMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            googleMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            googleMapView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        poiButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            poiButton.widthAnchor.constraint(equalToConstant: 50),
            poiButton.heightAnchor.constraint(equalToConstant: 50),
            poiButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -50),
            poiButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            ])
        poiButton.backgroundColor = .white
        view.backgroundColor = .white
        
    }
    
    private func configureGMView() {
        googleMapView.isMyLocationEnabled = true
        googleMapView.delegate = self
        self.googleMapViewPaddingConfiguration()
    }
    
    private func configureExpandButton()  {
        self.poiButton.buttonAction = {
            self.displayCollectionView()
        }
    }
    
    private func displayCollectionView() {
           if let sheet = collectionView.sheetPresentationController {
               sheet.detents = [.medium(), .large()]
               sheet.largestUndimmedDetentIdentifier = .medium
               sheet.prefersScrollingExpandsWhenScrolledToEdge = false
               sheet.prefersEdgeAttachedInCompactHeight = true
               sheet.prefersGrabberVisible = true
           }
        if let myLocation = self.googleMapView.myLocation {
            self.googleMapView.animate(toLocation: myLocation.coordinate)  
        }
           present(collectionView, animated: true, completion: {})
    }
    
    private func displaySinglePlaceView(for place: PlaceViewModel) {
        
        let viewController = PlaceDetailsViewController(viewModel: place)
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.prefersGrabberVisible = true
        }
        
        self.collectionView.dismiss(animated: true) {
            self.present(viewController, animated: true)
        }
    }

    private func configureCollectionView() {
        collectionView.collectionView.dataSource = self
        collectionView.collectionView.delegate = self
        collectionView.collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        collectionView.collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.collectionView.backgroundColor = .white
    }
    
    private func placeMarkers(for places: [PlaceViewModel]) {
        googleMapView.clear()
        places.forEach({createMarker(for: $0)})
    }

    private func createMarker(for place: PlaceViewModel) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        marker.title = place.title
        marker.map = googleMapView
    }

    private func zoom(to location: CLLocation) {
        googleMapView.animate(toLocation: location.coordinate)
        googleMapView.animate(toZoom: 17)
    }

    private func configureGMCamera(with location: CLLocation) {
        self.googleMapView.animate(to: GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15))

    }
    
    private func googleMapViewPaddingConfiguration() {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: self.view.frame.height/2, right: 0)
        googleMapView.padding = insets
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
            viewModel.selectTag(at: indexPath.row)
        }

    private func selectedPlaceCell(_ collectionView: UICollectionView, at indexPath: IndexPath) {
// TODO: - Display place details
    }

}

extension MainPageContainerViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let location = Coordinates(
            latitude: marker.position.latitude,
            longitude: marker.position.longitude)
        viewModel.selectPlace(atLocation: location)
        return false
    }
}
