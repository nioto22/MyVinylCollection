//
//  CollectionViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 04/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import AlamofireImage

class CollectionViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutButtonLabel: UILabel!
    @IBOutlet weak var sortingButtonLabel: UILabel!
    
    var userCollection: [Album]! = []
    var layoutChoosen: Int!
    var cellSize: CGSize!
    let coverCollectionViewCellIdentifier = "CoverCollectionViewCell"
    enum layoutType: Int {
        case ListView = 0
        case SmallCover = 1
        case MediumCover = 2
        case LargeCover = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO get user defaults preferences on cover size
        layoutChoosen = layoutType.SmallCover.rawValue
        configureCollectionViewLayout(type: layoutChoosen)
        
        refreshCollectionAlbumList()
    }
    
    func refreshAllViews(){
        configureCollectionViewLayout(type: layoutChoosen)
        collectionView.reloadData()
        print(userCollection.count)
    }
    
    // MARK: - Action Methods
    
    @IBAction func layoutSizeButtonClicked(_ sender: Any) {
        switch layoutChoosen {
        case 0:
            layoutChoosen += 1
            layoutButtonLabel.text = "Small Covers"
            break
        case 1:
            layoutChoosen += 1
            layoutButtonLabel.text = "Medium Covers"
            break
        case 2:
            layoutChoosen += 1
            layoutButtonLabel.text = "Large Covers"
            break
        case 3:
            layoutChoosen = 0
            layoutButtonLabel.text = "List View"
            break
        default:
            break
        }
        refreshAllViews()
        
    }
    
    @IBAction func sortingButtonClicked(_ sender: Any) {
    }
    
    func refreshCollectionAlbumList(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        let typePredicate = NSPredicate(format: "albumInCollection = %@", "true")
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.predicate = typePredicate
        //fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            userCollection = try context.fetch(fetchRequest) as? [Album]
        } catch {
            print("Context could not send data")
        }
        refreshAllViews()
    }

    // MARK: - CollectionView Methods
    
    func configureCollectionViewLayout(type: Int){
        let layout = collectionView.collectionViewLayout
        let dividSize = (type == 1) ? 4 : (type == 2) ? 3 : 2
        let cellWidth = (Double(layout.collectionViewContentSize.width)/Double(dividSize))
        let cellHeight = cellWidth
        

        cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        let spLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        spLayout.itemSize = cellSize
        spLayout.minimumLineSpacing = 0
        spLayout.minimumInteritemSpacing = 0
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: coverCollectionViewCellIdentifier, for: indexPath) as! MediumCoversCollectionViewCell
        cell.albumNameLabel.text = userCollection[indexPath.row].albumName
        cell.artistNameLabel.text = userCollection[indexPath.row].artistsName
        if let urlSt = userCollection[indexPath.row].imageSmall {
            if let imageURL = URL(string: urlSt), let placeholder = UIImage(named: "platinIcon") {
                cell.coverImageView.af_setImage(withURL: imageURL, placeholderImage: placeholder) //set image automatically when download compelete.
            }
        }
        return cell
    }
    


//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return cellSize
//    }
    
}
