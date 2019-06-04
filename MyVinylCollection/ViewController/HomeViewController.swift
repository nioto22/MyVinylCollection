//
//  ViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 03/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    // FOR DESIGN
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMemberDateLabel: UILabel!
    
    @IBOutlet weak var userSellerRateLabel: UILabel!
    @IBOutlet weak var userBuyerRateLabel: UILabel!
    
    @IBOutlet weak var starOneSellerImageView: UIImageView!
    @IBOutlet weak var starTwoSellerImageView: UIImageView!
    @IBOutlet weak var starThreeSellerImageView: UIImageView!
    @IBOutlet weak var starFourSellerImageView: UIImageView!
    @IBOutlet weak var starFiveSellerImageView: UIImageView!
    @IBOutlet weak var starOneBuyerImageView: UIImageView!
    @IBOutlet weak var starTwoBuyerImageView: UIImageView!
    @IBOutlet weak var starThreeBuyerImageView: UIImageView!
    @IBOutlet weak var starFourBuyerImageView: UIImageView!
    @IBOutlet weak var starFiveBuyerImageView: UIImageView!
    
    @IBOutlet weak var minCollectionValueLabel: UILabel!
    @IBOutlet weak var medCollectionValueLabel: UILabel!
    @IBOutlet weak var maxCollectionValueLabel: UILabel!
    
    @IBOutlet weak var collectionCountLabel: UILabel!
    @IBOutlet weak var wantlistCountLabel: UILabel!
    
    @IBOutlet weak var collectionCollectionView: UICollectionView!
    @IBOutlet weak var wantlistCollectionView: UICollectionView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        

        
    }

    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-30)
    }
    
    

}

