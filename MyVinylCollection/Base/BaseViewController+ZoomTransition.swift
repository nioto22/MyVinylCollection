//
//  BaseViewController+ZoomTransition.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 10/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import Foundation
import ZoomTransitioning

extension BaseViewController: ZoomTransitionSourceDelegate {
    var animationDuration: TimeInterval {
        return 0.4
    }
    
    func transitionSourceImageView() -> UIImageView {
        return selectedImageView ?? UIImageView()
    }
    
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect {
        guard let selectedImageView = selectedImageView else { return .zero }
        return selectedImageView.convert(selectedImageView.bounds, to: view)
    }
    
    func transitionSourceWillBegin() {
        selectedImageView?.isHidden = true
    }
    
    func transitionSourceDidEnd() {
        selectedImageView?.isHidden = false
    }
    
    func transitionSourceDidCancel() {
        selectedImageView?.isHidden = false
    }
}


