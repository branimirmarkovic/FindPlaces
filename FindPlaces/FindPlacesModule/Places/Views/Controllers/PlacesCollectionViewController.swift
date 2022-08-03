//
//  PlacesCollectionViewController.swift
//  FindPlaces
//
//  Created by Branimir Markovic on 21.4.22..
//

import Foundation
import UIKit
import UBottomSheet


class PlacesCollectionViewController: UICollectionViewController, Draggable {
    
    var sheetCoordinator: UBottomSheetCoordinator? 

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func draggableView() -> UIScrollView? {
        return collectionView
    }
    
    
}
