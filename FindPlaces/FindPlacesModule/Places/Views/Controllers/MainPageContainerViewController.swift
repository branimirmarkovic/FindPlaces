//
//  MainPageContainerViewController.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import MapKit


class MainPageContainerViewController: UIViewController {
    
    var singlePLaceControllerPresentationHandler: ((PlaceViewModel) -> Void)?
    
    private let collectionView: PlacesCollectionViewController
    private let mapView: MKMapView
    private let viewModel: MainPageCompositeViewModel
    private let notificationService: NotificationService
    private var placeCells: [PlaceCellController] = []
    private let poiButton: PointOfInterestExpandButton = PointOfInterestExpandButton(action: nil)
    
    init(
        viewModel: MainPageCompositeViewModel,
        notificationService: NotificationService,
        layoutProvider: CollectionViewLayoutFactory
    ) {
        self.viewModel = viewModel
        self.notificationService = notificationService
        self.mapView = MKMapView()
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
        viewModel.load(in: viewModel.startingRegion)
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
                self.collectionView.collectionView.reloadData()
                self.notificationService.stopSpinner()
            }
        }
        
        viewModel.onPlaceSelection = { placeViewModel in 
            if let placeViewModel = placeViewModel {
                if let presentedViewController = self.presentedViewController {
                    presentedViewController.dismiss(animated: true) {
                        self.singlePLaceControllerPresentationHandler?(placeViewModel)
                        self.mapView.zoomTo(coordinates: placeViewModel.coordinates, viewSize: CGSize(width: 80, height: 80))
                    }
                } else {
                    self.singlePLaceControllerPresentationHandler?(placeViewModel)
                }
            }
        }
        
        viewModel.onPOICategoriesLoadStart = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.notificationService.showSpinner(on: self.collectionView.collectionView)
            }
        }
        
        viewModel.onPOICategoriesLoad = {[weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.collectionView.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
        
        viewModel.onPOICategoriesSelection = {[weak self] in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.collectionView.collectionView.reloadData()
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
        configureMapView()
        configureExpandButton()
    }
    
    private func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(poiButton)
    }
    
    private func configureLayout() {
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        poiButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            poiButton.widthAnchor.constraint(equalToConstant: 50),
            poiButton.heightAnchor.constraint(equalToConstant: 50),
            poiButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -50),
            poiButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            ])
        view.backgroundColor = .white
        
    }
    
    private func configureMapView() {
        mapView.showsUserLocation = true
        mapView.region = MKCoordinateRegion(loadRegion: viewModel.startingRegion)
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
        collectionView.collectionView.register(POICategoryCollectionViewCell.self, forCellWithReuseIdentifier: POICategoryCollectionViewCell.identifier)
        collectionView.collectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
        collectionView.collectionView.register(POICategoryCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: POICategoryCollectionViewHeader.identifier)
        collectionView.collectionView.register(NoPlaceResultsCell.self, forCellWithReuseIdentifier: NoPlaceResultsCell.identifier)
        collectionView.collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.identifier)
        collectionView.collectionView.backgroundColor = .white
    }

}

     // MARK: - Collection View Data Source
extension MainPageContainerViewController: UICollectionViewDataSource {

     func numberOfSections(in collectionView: UICollectionView) -> Int {
         viewModel.numberOfSections
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.categoriesCountCount
        case 1 :
            return viewModel.placesCount
        case 2: 
            return viewModel.noResultsItemsCount
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard indexPath.section == 1 else {return UICollectionReusableView()}
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: POICategoryCollectionViewHeader.identifier, for: indexPath) as! POICategoryCollectionViewHeader
            let viewModel = viewModel.selectedCategoryViewModel()
            viewModel?.selectionHandler = { [weak self] in 
                self?.viewModel.deselectSelectedCategory()
            }
            sectionHeader.poiViewModel = viewModel
                 return sectionHeader
            } else { 
                 return UICollectionReusableView()
            }
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return dequeuePOICategoryCell(collectionView, for: indexPath, poi: viewModel.category(at: indexPath.row))
        case 1:
            return placeCells[indexPath.row].dequeueCell(collectionView, for: indexPath, place: viewModel.place(at: indexPath.row))
        case 2:
            if placeCells.isEmpty {
                return collectionView.dequeueReusableCell(withReuseIdentifier: NoPlaceResultsCell.identifier, for: indexPath)
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.identifier, for: indexPath)
            } 
            
        default :
            return UICollectionViewCell()
        }
    }

    private func dequeuePOICategoryCell(_ collectionView: UICollectionView, for indexPath: IndexPath, poi: PointOfInterestCategoryViewModel?) -> POICategoryCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: POICategoryCollectionViewCell.identifier, for: indexPath) as? POICategoryCollectionViewCell
        cell?.poiViewModel = poi

        return cell ?? POICategoryCollectionViewCell()
    }

    
}
    // MARK: - Collection View Delegate
extension MainPageContainerViewController: UICollectionViewDelegate {
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectedCategoryCell(collectionView, at: indexPath)
        case 1:
            selectedPlaceCell(collectionView, at: indexPath)
        default :
            ()
        }
    }

        private func selectedCategoryCell(_ collectionView: UICollectionView, at indexPath: IndexPath) {
            viewModel.selectCategory(at: indexPath.row)
        }

    private func selectedPlaceCell(_ collectionView: UICollectionView, at indexPath: IndexPath) {
        viewModel.selectPlace(at: indexPath.row)
    }

}
