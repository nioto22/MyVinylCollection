//
//  NavigationController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 10/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit
import ZoomTransitioning

class NavigationController: UINavigationController {

    private let zoomNavigationControllerDelegate = ZoomNavigationControllerDelegate()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        delegate = zoomNavigationControllerDelegate
    }

}
