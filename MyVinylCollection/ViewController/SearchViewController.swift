//
//  SearchViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 04/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import ZoomTransitioning

class SearchViewController: UITableViewController, UISearchBarDelegate  {

    
    var userCollection: [Album]! = []
    var searchHistoryList: [Album]! = []
    var selectedAlbum: Album! = nil
    //MARK: - Variables
    // FOR DESIGN
    @IBOutlet var searchTableView: UITableView!
    let tableViewCellIdentifier = "listViewTableViewCell"
    var navSearchBar = UISearchBar()
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    var searchButtonClickCount = 0
    
    var logoImageView: UIImageView!
    
    // FOR DATA
    // ZoomTransition
    var selectedImageView: UIImageView?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.dataSource = self
        searchTableView.delegate = self

        setUpTitle()
        navSearchBar.delegate = self
        navSearchBar.backgroundColor = UIColor.MyVinylCollection.ViewColor.BackgroundDark
        navSearchBar.placeholder = "Search in Discogs..."
        let textFieldInsideSearchBar = navSearchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
        navSearchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBarButton = navigationItem.rightBarButtonItem
        
        
        
        getListOfAlbum()
        

    }
    
    func setUpTitle(){
            let logoImage = UIImage.init(named: "titleAppSmallIcon")
            logoImageView = UIImageView.init(image: logoImage)
            logoImageView.frame = CGRect(x: -40,y: 0,width:  85,height:  25)
            logoImageView.contentMode = .scaleAspectFit
            let imageItem = UIBarButtonItem.init(customView: logoImageView)
            let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -25
            navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
    }
    
    func getListOfAlbum(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        let typePredicate = NSPredicate(format: "albumInCollection = %@", "false")
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.predicate = typePredicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            userCollection = try context.fetch(fetchRequest) as? [Album]
        } catch {
            print("Context could not send data")
        }
        
        for index in 1...5 {
            searchHistoryList.append(userCollection[index])
        }
    }
    
    func setLabels(notification: NSNotification){
        
        // Use the data from DataService.swift to initialize the Album.
//        _ = Album(album: DataService.dataService.ALBUM_FROM_DISCOGS,
//                              artist: "",
//                              albumPicture: "",
//                              albumFormat: "",
//                              albumLabel: "",
//                              albumYear: DataService.dataService.YEAR_FROM_DISCOGS)
        //artistAlbumLabel.text = "\(albumInfo.album)"
        //yearLabel.text = "\(albumInfo.year)"
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return searchHistoryList.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = searchTableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! ListViewTableViewCell
        cell.artistAlbumLabel.text = (searchHistoryList[indexPath.row].albumName ?? "") + " - " + (searchHistoryList[indexPath.row].artistsName ?? "")
        cell.formatAlbumLabel.text = "Format: " + (searchHistoryList[indexPath.row].formatsName ?? "Vinyl")
        cell.labelAlbumLabel.text = "Label: " + (searchHistoryList[indexPath.row].labelName ?? "No Label")
        cell.yearAlbumLabel.text = "Released in " + (searchHistoryList[indexPath.row].year ?? "2001")
        if let urlSt = searchHistoryList[indexPath.row].imageSmall {
            if let imageURL = URL(string: urlSt), let placeholder = UIImage(named: "platinIcon") {
                cell.albumPictureImageView.af_setImage(withURL: imageURL, placeholderImage: placeholder) //set image automatically when download compelete.
            }
        }
         return cell
     }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAlbum = searchHistoryList[indexPath.row]
        let cell = searchTableView.cellForRow(at: indexPath) as! ListViewTableViewCell
        selectedImageView = cell.albumPictureImageView
        performSegue(withIdentifier: "toAlbumDetailVCSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbumDetailVCSegue" {
            if let detailVC = segue.destination as? AlbumDetailViewController{
                detailVC.album = selectedAlbum
                detailVC.largeImageView = selectedImageView
            }
        }
    }
    
    // MARK: - SearchBar methods
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    // MARK: - Actions Methods
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        if (searchButtonClickCount == 0 ){
            showSearchBar()
            hideSearchBar()
            showSearchBar()
            hideSearchBar()
            showSearchBar()
            searchButtonClickCount += 5
        } else if (searchButtonClickCount % 2 == 0){
            showSearchBar()
            searchButtonClickCount += 1
        } else {
            hideSearchBar()
            searchButtonClickCount += 1
        }
        
//        if(searchBar.isHidden) {
//            searchBar.isHidden = false
//        }else {
//           searchBar.isHidden = true
//        }
        // TODO SEARCH IN DISCOGS
    }
    
    @IBAction func searchCodeBarButtonClicked(_ sender: Any) {
    }
    
    
    func showSearchBar() {
        //searchBarButton.image = UIImage(named: "cancelIcon")
        navigationItem.titleView = navSearchBar
        navSearchBar.alpha = 0
        navigationItem.setLeftBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.navSearchBar.alpha = 1
        }, completion: { finished in
            self.navSearchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        //navSearchBar.isHidden = true
        //searchBarButton.image = UIImage(named: "searchIcon")
        navigationItem.setLeftBarButton(searchBarButton, animated: true)
        let logoImage = UIImage.init(named: "titleAppSmallIcon")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: -250,y: 0,width:  85,height: 20)
        logoImageView.contentMode = .scaleAspectFit
       // let imageItem = UIBarButtonItem.init(customView: logoImageView)
        //        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        //        negativeSpacer.width = -25
        //        navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: logoImageView)
        logoImageView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationItem.titleView = logoImageView
            logoImageView.alpha = 1
        }, completion: { finished in

        })
    }

}

extension SearchViewController: ZoomTransitionSourceDelegate {
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
