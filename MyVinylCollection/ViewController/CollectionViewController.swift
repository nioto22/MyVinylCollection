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

class CollectionViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    

 
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutButtonLabel: UILabel!
    @IBOutlet weak var sortingButtonLabel: UILabel!
    
    var userCollection: [Album]! = []
    var filteredUserCollection: [Album]! = []

    var cellSize: CGSize!
    let coverCollectionViewCellIdentifier = "CollectionCollectionViewCell"
    let toAlbumDetailSegueIdentifier = "toAlbumDetailSegue"
    
    var layoutChoosen: Int!
    enum layoutType: Int {
        case ListView = 0
        case SmallCover = 1
        case MediumCover = 2
        case LargeCover = 3
    }
    var sortingTypeChoosen: String!
    enum sortingType: String {
        case TitleAZ = "Title (A-Z)"
        case TitleZA = "Title (Z-A)"
        case ArtistAZ = "Artist (A-Z)"
        case ArtistZA = "Artist (Z-A)"
        case NewestAdded = "Newest Added"
    }
    
    var albumClicked: Album! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TODO get user defaults preferences on cover size
        layoutChoosen = layoutType.SmallCover.rawValue
        layoutButtonLabel.text = "Small Covers"
        sortingTypeChoosen = sortingType.NewestAdded.rawValue
        sortingButtonLabel.text = sortingTypeChoosen
        
        
        refreshCollectionAlbumList()

    }
    
    func refreshAllViews(){
        collectionView.reloadData()
    }
    
    // MARK: - Action Methods
    
    @IBAction func layoutSizeButtonClicked(_ sender: Any) {
        showAlertLayoutTypeBox()
    }
    
    @IBAction func sortingButtonClicked(_ sender: Any) {
        showAlertSortingTypeBox()
    }

    
    func showAlertLayoutTypeBox(){
    let alert = UIAlertController(title: "Select layout", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "List View", style: .default, handler: { action in
            self.changingLayout(0)
        }))
        alert.addAction(UIAlertAction(title: "Small Covers", style: .default, handler: { action in
            self.changingLayout(1)
        }))
        alert.addAction(UIAlertAction(title: "Medium Covers", style: .default, handler: { action in
            self.changingLayout(2)
        }))
        alert.addAction(UIAlertAction(title: "Large Covers", style: .default, handler: { action in
            self.changingLayout(3)
        }))
    
    self.present(alert, animated: true)
    }
    
    func showAlertSortingTypeBox() {
        let alert = UIAlertController(title: "Sort by", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Album Title    (A-Z)", style: .default, handler: { action in
            self.changingSort(sortingType.TitleAZ.rawValue)
        }))
        alert.addAction(UIAlertAction(title: "Album Title    (Z-A)", style: .default, handler: { action in
            self.changingSort(sortingType.TitleZA.rawValue)
        }))
        alert.addAction(UIAlertAction(title: "Artist Name    (A-Z)", style: .default, handler: { action in
            self.changingSort(sortingType.ArtistAZ.rawValue)
        }))
        alert.addAction(UIAlertAction(title: "Artist Name    (Z-A)", style: .default, handler: { action in
            self.changingSort(sortingType.ArtistZA.rawValue)
        }))
        alert.addAction(UIAlertAction(title: "Newest Added", style: .default, handler: { action in
            self.changingSort(sortingType.NewestAdded.rawValue)
        }))
        
        self.present(alert, animated: true)
    }
    
    func changingLayout(_ type: Int){
        switch type {
        case 0:
            layoutChoosen = 0
            layoutButtonLabel.text = "List View"
            break
        case 1:
            layoutChoosen = 1
            layoutButtonLabel.text = "Small Covers"
            break
        case 2:
            layoutChoosen = 2
            layoutButtonLabel.text = "Medium Covers"
            break
        case 3:
            layoutChoosen = 3
            layoutButtonLabel.text = "Large Covers"
            break
        default:
            break
        }
        refreshAllViews()
    }
    
    func changingSort(_ type: String){
            sortingTypeChoosen = type
            sortingButtonLabel.text = type
        refreshCollectionAlbumList()
        refreshAllViews()
    }
    
    func refreshCollectionAlbumList(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        let typePredicate = NSPredicate(format: "albumInCollection = %@", "true")
        //let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        let sortDescriptor = getSortType()
        fetchRequest.predicate = typePredicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            userCollection = try context.fetch(fetchRequest) as? [Album]
        } catch {
            print("Context could not send data")
        }
        refreshAllViews()
    }
    
    
    func getSortType() -> NSSortDescriptor {
        let sortDescriptor: NSSortDescriptor!
        
        switch sortingTypeChoosen {
        case sortingType.TitleAZ.rawValue :
            sortDescriptor = NSSortDescriptor(key: "albumName", ascending: true)
            break
        case sortingType.TitleZA.rawValue :
            sortDescriptor = NSSortDescriptor(key: "albumName", ascending: false)
            break
        case sortingType.ArtistAZ.rawValue :
            sortDescriptor = NSSortDescriptor(key: "artistsName", ascending: true)
            break
        case sortingType.ArtistZA.rawValue :
            sortDescriptor = NSSortDescriptor(key: "artistsName", ascending: false)
            break
        case sortingType.NewestAdded.rawValue :
            sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
            break
        default :
            sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
            break
        }
        return sortDescriptor
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
        //collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearchActivated() ? filteredUserCollection.count : userCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: coverCollectionViewCellIdentifier, for: indexPath) as! CollectionCoversCollectionViewCell
        cell.albumNameLabel.text = isSearchActivated() ? filteredUserCollection[indexPath.row].albumName : userCollection[indexPath.row].albumName
        cell.artistNameLabel.text = isSearchActivated() ? filteredUserCollection[indexPath.row].artistsName : userCollection[indexPath.row].artistsName
        if let urlSt = isSearchActivated() ? filteredUserCollection[indexPath.row].imageSmall : userCollection[indexPath.row].imageSmall {
            if let imageURL = URL(string: urlSt), let placeholder = UIImage(named: "platinIcon") {
                cell.coverImageView.af_setImage(withURL: imageURL, placeholderImage: placeholder) //set image automatically when download compelete.
            }
        }
        configureCollectionViewLayout(type: layoutChoosen)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        albumClicked = isSearchActivated() ? filteredUserCollection[indexPath.row] : userCollection[indexPath.row]
        print(albumClicked.id ?? "")
        performSegue(withIdentifier: toAlbumDetailSegueIdentifier, sender: self)
    }
    
    // MARK: - UISearchController
    
    func searchBarIsEmpty() -> Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    func filterContent(for searchText: String) {
        // Update the searchResults array with matches
        // in our entries based on the title value.
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredUserCollection = userCollection.filter{
                album in
                return (album.albumName!.lowercased().contains(searchText.lowercased()) || album.artistsName!.lowercased().contains(searchText.lowercased()))
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if let searchText = searchBar.text {
            filterContent(for: searchText)
            // Reload the table view with the search result data.
            collectionView.reloadData()
        }
    }
    
    func isSearchActivated() -> Bool {
        return !searchBarIsEmpty()
    }
    
    // MARK: - Navigators
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                switch segue.identifier{
                case toAlbumDetailSegueIdentifier:
                    if let albumDetailVC = segue.destination as? AlbumDetailViewController{
                       albumDetailVC.album = albumClicked
                    }
                    break
                default:
                    break
                }
            }
    
}
