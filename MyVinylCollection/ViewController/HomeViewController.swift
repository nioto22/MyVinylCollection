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
    var wantlistCollection: [Album] = []
    typealias FinishedDownload = () -> ()
    let HomeCollectionViewCellIdentifier = "HomeCollectionViewCell"
    
    var userInfo: [String: Any] = [:]
    // userInfoKey
    let userPseudoKey = "userPseudoKey"
    let memberDateKey = "memberDateKey"
    let userAvatarKey = "userAvatarKey"
    let sellerRatingPourcentageKey = "sellerRatingPourcentageKey"
    let buyerRatingPourcentageKey = "buyerRatingPourcentageKey"
    let sellerRatingKey = "sellerRatingKey"
    let buyerRatingKey = "buyerRatingKey"
    let sellerStarsNumberKey = "sellerStarsNumberKey"
    let buyerStarsNumberKey = "buyerStarsNumberKey"
    let collectionCountKey = "collectionCountKey"
    let wantlistCountKey = "wantlistCountKey"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        
        collectionCollectionView.dataSource = self
        collectionCollectionView.delegate = self
        let collectionLayout = collectionCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionLayout.scrollDirection = .horizontal
        let wantlistLayout = wantlistCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        wantlistLayout.scrollDirection = .horizontal
        wantlistCollectionView.dataSource = self
        wantlistCollectionView.delegate = self
        
        getUserInformation()
        getUserCollection()
 
    }
    

    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-30)
    }
    
    
// MARK: - SetUpViews
    func refreshAllViews(){
        refreshCollectionViews()
        setUpUserInformations()
        setUpCollectionsUpperViews()
    }
    
    func refreshCollectionViews(){
        collectionCollectionView.reloadData()
        wantlistCollectionView.reloadData()
    }
    
    func setUpUserInformations(){
        userNameLabel.text = userInfo[self.userPseudoKey] as? String
        let st = userInfo[self.memberDateKey] as! String
        let dateSt = st.prefix(10)
        print(dateSt)
        let memberDateFormated = "Member since : " + dateSt
        userMemberDateLabel.text = memberDateFormated
        let sellerStarsCountD = userInfo[self.sellerStarsNumberKey] as? Double
        let sellerStarsCount = Int(sellerStarsCountD!)
        let buyerStarsCountD = userInfo[self.buyerStarsNumberKey] as? Double
        let buyerStarsCount = Int(buyerStarsCountD!)
        setUpUserStars(sellerCount: sellerStarsCount, buyerCount: buyerStarsCount)
        let sellRatPourc = userInfo[self.sellerRatingPourcentageKey] as? Double ?? 0.0
        let sellRat = userInfo[self.sellerRatingKey] as? Int ?? 0
        let sellerRatingString = String(sellRatPourc) + "% (" + String(sellRat) + " ratings)"
        let buyRatPourc = userInfo[self.buyerRatingPourcentageKey] as? Double ?? 0.0
        let buyRat = userInfo[self.buyerRatingKey] as? Int ?? 0
        let buyerRatingString = String(buyRatPourc) + "% (" + String(buyRat) + " ratings)"
        userSellerRateLabel.text = sellerRatingString
        userBuyerRateLabel.text = buyerRatingString
    }
    
    func setUpCollectionsUpperViews(){
        let collecCount = userInfo[collectionCountKey] as? Int ?? 0
        collectionCountLabel.text = "View all " +  String(collecCount)
        let wantlistCount = userInfo[wantlistCountKey] as? Int ?? 0
        wantlistCountLabel.text = "View all " +  String(wantlistCount)
    }
    
    func setUpUserStars(sellerCount: Int, buyerCount: Int){
        let starIn = "starYellowIcon"
        let starOut = "starGreyIcon"
        
        starOneSellerImageView.image = UIImage(named: starOut)
        starTwoSellerImageView.image = UIImage(named: starOut)
        starThreeSellerImageView.image = UIImage(named: starOut)
        starFourSellerImageView.image = UIImage(named: starOut)
        starFiveSellerImageView.image = UIImage(named: starOut)
        starOneBuyerImageView.image = UIImage(named: starOut)
        starTwoBuyerImageView.image = UIImage(named: starOut)
        starThreeBuyerImageView.image = UIImage(named: starOut)
        starFourBuyerImageView.image = UIImage(named: starOut)
        starFiveBuyerImageView.image = UIImage(named: starOut)
        
        switch sellerCount {
        case 5:
           starOneSellerImageView.image = UIImage(named: starIn)
           starTwoSellerImageView.image = UIImage(named: starIn)
           starThreeSellerImageView.image = UIImage(named: starIn)
           starFourSellerImageView.image = UIImage(named: starIn)
           starFiveSellerImageView.image = UIImage(named: starIn)
            break
        case 4:
            starOneSellerImageView.image = UIImage(named: starIn)
            starTwoSellerImageView.image = UIImage(named: starIn)
            starThreeSellerImageView.image = UIImage(named: starIn)
            starFourSellerImageView.image = UIImage(named: starIn)
            break
        case 3:
            starOneSellerImageView.image = UIImage(named: starIn)
            starTwoSellerImageView.image = UIImage(named: starIn)
            starThreeSellerImageView.image = UIImage(named: starIn)
            break
        case 2:
            starOneSellerImageView.image = UIImage(named: starIn)
            starTwoSellerImageView.image = UIImage(named: starIn)
            break
        case 1:
            starOneSellerImageView.image = UIImage(named: starIn)
            break
        default:
            break
        }
        
        switch buyerCount {
        case 5:
            starOneBuyerImageView.image = UIImage(named: starIn)
            starTwoBuyerImageView.image = UIImage(named: starIn)
            starThreeBuyerImageView.image = UIImage(named: starIn)
            starFourBuyerImageView.image = UIImage(named: starIn)
            starFiveBuyerImageView.image = UIImage(named: starIn)
            break
        case 4:
            starOneBuyerImageView.image = UIImage(named: starIn)
            starTwoBuyerImageView.image = UIImage(named: starIn)
            starThreeBuyerImageView.image = UIImage(named: starIn)
            starFourBuyerImageView.image = UIImage(named: starIn)
            break
        case 3:
            starOneBuyerImageView.image = UIImage(named: starIn)
            starTwoBuyerImageView.image = UIImage(named: starIn)
            starThreeBuyerImageView.image = UIImage(named: starIn)
            break
        case 2:
            starOneBuyerImageView.image = UIImage(named: starIn)
            starTwoBuyerImageView.image = UIImage(named: starIn)
            break
        case 1:
            starOneBuyerImageView.image = UIImage(named: starIn)
            break
        default:
            break
        }
    }
    
    
    // MARK: - CollectionViews Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionCollectionView {
            return 1
        } else if (collectionView == self.wantlistCollectionView) {
            return 1
        } else {
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionCollectionView {
            if userCollection.count > 9 {
                return 10
            } else {
                return userCollection.count
            }
        } else if (collectionView == self.wantlistCollectionView) {
            if wantlistCollection.count > 9 {
                return 10
            } else {
                return wantlistCollection.count
            }
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: homeCollectionViewCell!
        cell = (collectionView == self.collectionCollectionView) ?
            (self.collectionCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCellIdentifier, for: indexPath) as! homeCollectionViewCell)
        : (self.wantlistCollectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCellIdentifier, for: indexPath) as! homeCollectionViewCell)
        if (collectionView == self.collectionCollectionView){
            for album in userCollection {
            }
            //cell.albumCoverImageView = self.userCollection[indexPath.row].imageSmall
            cell.albumTitleLabel.text = userCollection[indexPath.row].albumName
            cell.albumArtistLabel.text = userCollection[indexPath.row].artistsName
            
        } else if (collectionView == self.wantlistCollectionView) {
            
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
        refreshAllViews()
        
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
                        
                        guard let albumId = release["id"] as? Int else {
                            continue
                        }
                        
                        var album = self.albumAlreadyExists(id: String(albumId))
                        if album == nil {
                            album = NSManagedObject(entity: entity!, insertInto: context) as? Album
                            album?.id = String(albumId)
                        }
                        // Date Added
                        if let date = release["date_added"] as? String {
                            album?.dateAdded = date
                        }
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
    
    func albumAlreadyExists(id: String) -> Album?{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            userCollection = try context.fetch(fetchRequest) as! [Album]
            
            if (userCollection.count > 0){
                return userCollection.first
            }
        } catch {
            print("context could not save data")
        }
        return nil

    }
    
    

    func getUserInformation() {
        
        let userInfoURL = DISCOGS_USER_INFORMATION
        
        Alamofire.request(userInfoURL)
            .responseJSON { response in
                
                // check for errors
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on /todos/1")
                    print(response.result.error!)
                    return
                }
                
                // make sure we got some JSON since that's what we expect
                guard let userInfoJsonArray = response.result.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.result.error {
                        print("Error: \(error)")
                    }
                    return
                }
                if let memberDate = userInfoJsonArray["registered"] as? String {
                    self.userInfo[self.memberDateKey] = memberDate
                }
                if let userPseudo = userInfoJsonArray["username"] as? String {
                    self.userInfo[self.userPseudoKey] = userPseudo
                }
                if let userAvatar = userInfoJsonArray["avatar_url"] as? String {
                    self.userInfo[self.userAvatarKey] = userAvatar
                }
                if let sellerRatingPourcentage = userInfoJsonArray["seller_rating"] as? Double {
                    self.userInfo[self.sellerRatingPourcentageKey] = sellerRatingPourcentage
                }
                if let buyerRatingPourcentage = userInfoJsonArray["buyer_rating"] as? Double {
                    self.userInfo[self.buyerRatingPourcentageKey] = buyerRatingPourcentage
                }
                if let sellerRating = userInfoJsonArray["seller_num_rating"] as? Int {
                    self.userInfo[self.sellerRatingKey] = sellerRating
                }
                if let buyerRating = userInfoJsonArray["buyer_num_ratings"] as? Int {
                    self.userInfo[self.buyerRatingKey] = buyerRating
                }
                if let sellerStarsNumber = userInfoJsonArray["seller_rating_stars"] as? Double {
                    self.userInfo[self.sellerStarsNumberKey] = sellerStarsNumber
                }
                if let buyerStarsNumber = userInfoJsonArray["buyer_rating_stars"] as? Double {
                    self.userInfo[self.buyerStarsNumberKey] = buyerStarsNumber
                }
                if let collectionCount = userInfoJsonArray["num_collection"] as? Int {
                    self.userInfo[self.collectionCountKey] = collectionCount
                }
                if let wantlistCount = userInfoJsonArray["num_wantlist"] as? Int {
                    self.userInfo[self.wantlistCountKey] = wantlistCount
                }
                
        }
    }
}

