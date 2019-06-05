//
//  BaseViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 04/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    

    func setUpUI() {
        let logoImage = UIImage.init(named: "titleAppSmallIcon")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: -250,y: 0,width:  85,height: 20)
        logoImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem.init(customView: logoImageView)
//        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        negativeSpacer.width = -25
//        navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
        navigationItem.leftBarButtonItem = imageItem
    }

}
