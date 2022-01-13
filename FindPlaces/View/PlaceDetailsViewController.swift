//
//  PlaceDetailsViewController.swift
//  App
//
//  Created by Branimir Markovic on 18.12.21..
//

import Foundation
import UIKit


class PlaceDetailsViewController: UIViewController {

    private var placeViewModel: PlaceViewModel

    init(viewModel: PlaceViewModel) {
        self.placeViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
