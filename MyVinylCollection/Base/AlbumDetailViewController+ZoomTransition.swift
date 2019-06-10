//
//  AlbumDetailViewController+ZoomTransition.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 10/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import Foundation
import ZoomTransitioning

extension AlbumDetailViewController: ZoomTransitionDestinationDelegate {
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect {
        if forward {
            let x: CGFloat = 0.0
            let y = topLayoutGuide.length
            let width = view.frame.width
            let height = width * 2.0 / 3.0
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            return largeImageView.convert(largeImageView.bounds, to: view)
        }
    }
    
    func transitionDestinationWillBegin() {
        largeImageView.isHidden = true
    }
    
    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {
        largeImageView.isHidden = false
        largeImageView.image = imageView.image
    }
    
    func transitionDestinationDidCancel() {
        largeImageView.isHidden = false
    }
}

extension AlbumDetailViewController: ZoomTransitionSourceDelegate {
    func transitionSourceImageView() -> UIImageView {
        return smallImageView1
    }
    
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect {
        return smallImageView1.convert(smallImageView1.bounds, to: view)
    }
    
    func transitionSourceWillBegin() {
        smallImageView1.isHidden = true
    }
    
    func transitionSourceDidEnd() {
        smallImageView1.isHidden = false
    }
    
    func transitionSourceDidCancel() {
        smallImageView1.isHidden = false
    }
}
