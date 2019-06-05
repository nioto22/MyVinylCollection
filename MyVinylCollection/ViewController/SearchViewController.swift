//
//  SearchViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 04/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class SearchViewController: BaseTableViewController {
    
    //MARK: - Variables
    // FOR DESIGN
    @IBOutlet var searchTableView: UITableView!
    
    // FOR DATA


    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.dataSource = self
        searchTableView.delegate = self

        
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setLabels(_:)), name: "AlbumNotification", object: nil)

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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "listViewTableViewCell", for: indexPath)
        
         // Configure the cell...
        
         return cell
     }
 
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */



}
