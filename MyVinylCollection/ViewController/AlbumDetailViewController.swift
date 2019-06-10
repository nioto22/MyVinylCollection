//
//  AlbumDetailViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 10/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumDetailViewController: UIViewController {

    var album : Album! = nil
    
    
    @IBOutlet weak var largeImageView: UIImageView!
    
    @IBOutlet weak var smallImageView1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //smallImageView1.isHidden = true
        //getLargeImageView()
        
    }
    
    func getLargeImageView(){
        if let urlSt = album.image {
            if let imageURL = URL(string: urlSt) {
                largeImageView.af_setImage(withURL: imageURL)
            }
        }
    }


}
