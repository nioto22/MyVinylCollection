//
//  ViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 03/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire
import SwiftyJSON

class HomeViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

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
    
    // FOR DATA
    var userCollection: [Album] = []
    typealias FinishedDownload = () -> ()
    let HomeCollectionViewCellIdentifier = "HomeCollectionViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        collectionCollectionView.dataSource = self
        collectionCollectionView.delegate = self
        wantlistCollectionView.dataSource = self
        wantlistCollectionView.delegate = self
        
        getUserCollection()
 
    }
    

    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-30)
    }
    
    
    // Mark: - SetUpViews
    func refreshCollectionViews(){
        collectionCollectionView.reloadData()
        wantlistCollectionView.reloadData()
    }
    
    // Mark: - CollectionViews Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionCollectionView {
           return 10
        } else if (collectionView == self.wantlistCollectionView) {
            return 10
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCellIdentifier, for: indexPath)
        if (collectionView == self.collectionCollectionView){
            // setUp collectionCollectionView
        } else if (collectionView == self.wantlistCollectionView) {
            // setUp wantlistCollectionView
        }
        
        return cell
    }
    
    
    // MARK: - Discogs Request
    func refreshCollectionAlbumList(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            userCollection = try context.fetch(fetchRequest) as! [Album]
        } catch {
            print("Context could not send data")
        }
        refreshCollectionViews()
    }
    
    
    func getUserCollection() {
        
        let discogsUserCollectionURL = DISCOGS_USER_COLLECTION_URL
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Album", in: context)
        
        Alamofire.request(discogsUserCollectionURL)
            .responseJSON { response in
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let albumsJsonArray = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                if let releases = albumsJsonArray["releases"] as? [[String: Any]] {
                    
                    for release in releases {
                        
                        let album = NSManagedObject(entity: entity!, insertInto: context) as? Album
                        
                        // Date Added
                        if let date = release["date_added"] as? String {
                            album?.dateAdded = date
                        }
                        // Album Id
                        if let id = release["id"] as? Int {
                            album?.id = String(id)
                        }
                        //
                        // Gp : Basic Info
                        if let info = release["basic_information"] as? [String: Any]{
                            // Album name
                            if let title = info["title"] as? String {
                                album?.albumName = title
                            }
                            // Gp Artists
                            if let artist = info["artists"] as? [String: Any]{
                                if let artistName = artist["name"] as? String {
                                    album?.artistsName = artistName
                                }
                                if let artistId = artist["id"] as? Int {
                                    album?.artistsId = String(artistId)
                                }
                            }
                            // Gp Label
                            if let labels = info["labels"] as? [String: Any]{
                                if let labelName = labels["name"] as? String {
                                    album?.labelName = labelName
                                }
                            }
                            // Album year
                            if let year = info["year"] as? Int {
                                album?.year = String(year)
                            }
                            // Image album
                            if let image = info["cover_image"] as? String {
                                album?.image = image
                            }
                            // Small Image album
                            if let imageSmall = info["thumb"] as? String {
                                album?.imageSmall = imageSmall
                            }
                            // Gp : Format:
                            if let formats = info["formats"] as? [String: Any]{
                                if let formatName = formats["name"] as? String {
                                    album?.formatsName = formatName
                                }
                            }
                            // Track url
                            if let tracksURL = info["resource_url"] as? String {
                                album?.tracksURL = tracksURL
                            }
                        } 
                    }
                }
                do {
                    try context.save()
                } catch {
                    print("context could not save data")
                }
                self.refreshCollectionAlbumList()
        }
    }

    
    
}

