//
//  RoundedUIView.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 03/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

}
