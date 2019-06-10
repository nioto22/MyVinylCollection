//
//  AlbumDetailViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 10/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AlbumDetailViewController: UIViewController {

    var album : Album! = nil
    var artistImageUrl: String!
    
    @IBOutlet weak var largeImageView: UIImageView!
    
    @IBOutlet weak var smallImageView1: UIImageView!
    
    
    //Album Detail
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var albumTitleLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var resleaseDateLabel: UILabel!
    @IBOutlet weak var releaseFormatLabel: UILabel!
    @IBOutlet weak var labelNameLabel: UILabel!
    @IBOutlet weak var typeOfMusicLabel: UILabel!
    @IBOutlet weak var styleOfMusicLabel: UILabel!
    @IBOutlet weak var numberInCollectionLabel: UILabel!
    @IBOutlet weak var numberInWantlistLabel: UILabel!
   //Rated Stars
    @IBOutlet weak var ratedStarOneIV: UIImageView!
    @IBOutlet weak var ratedStarTwoIV: UIImageView!
    @IBOutlet weak var ratedStarThreeIV: UIImageView!
    @IBOutlet weak var ratedStarFourIV: UIImageView!
    @IBOutlet weak var ratedStarFiveIV: UIImageView!
   //Button Add to
    @IBOutlet weak var wantlistAddToButton: RoundedUIButton!
    @IBOutlet weak var collectionAddToButton: RoundedUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAllAlbumInfoDesign()
    }
    
    
    // MARK: - SetUp Design Methods
    
    func setUpAllAlbumInfoDesign(){
       // ToDo get infos from album.artistId and http request
            // artist image
        getArtistImage()
        albumTitleLabel.text = album.albumName ?? "Album Name"
        artistNameLabel.text = album.artistsName ?? "Artist Name"
        let releaseDateStartString = " Released in "
        resleaseDateLabel.text = releaseDateStartString + (album.year ?? "année")
        releaseFormatLabel.text = album.formatsName ?? "Vinyl"
        let labelNameStartString = "Label "
        labelNameLabel.text = labelNameStartString + (album.labelName ?? "label name")
        // ToDo get infos from album number get and number want
        if (album.albumInCollection == "true") {
            collectionAddToButton.backgroundColor = UIColor(red: 0, green: 255/255, blue: 179/255, alpha: 1)
        } else {
            wantlistAddToButton.backgroundColor = UIColor(red: 255/255, green: 73/255, blue: 74/255, alpha: 1)
        }
    }
    
    
    func getLargeImageView(){
        if let urlSt = album.image {
            if let imageURL = URL(string: urlSt) {
                largeImageView.af_setImage(withURL: imageURL)
            }
        }
    }

    // MARK: - Actions Methods
    
    @IBAction func addToCollectionButtonClicked(_ sender: Any) {
        let title: String!
        let alert: UIAlertController!
        if (album.albumInCollection == "true") {
            title = "Remove this release from your Collection ?"
        } else {
            title = "Add this release to your Collection ?"
        }
        
        alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: (album.albumInCollection == "true") ? .destructive : .default, handler: { action in
            if (self.album.albumInCollection == "true") {
                self.album.albumInCollection = "false"
                self.collectionAddToButton.backgroundColor = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
            } else {
                self.album.albumInCollection = "true"
                self.collectionAddToButton.backgroundColor = UIColor(red: 0, green: 255/255, blue: 179/255, alpha: 1)
            }
        }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
            
            self.present(alert, animated: true)
       
    }
    @IBAction func addToWantlistButtonClicked(_ sender: Any) {
        let title: String!
        let alert: UIAlertController!
        if (wantlistAddToButton.backgroundColor == UIColor(red: 255/255, green: 73/255, blue: 74/255, alpha: 1)) {
            title = "Remove this release from your Wantlist ?"
        } else {
            title = "Add this release to your Wantlist ?"
        }
        
        alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: (wantlistAddToButton.backgroundColor == UIColor(red: 255/255, green: 73/255, blue: 74/255, alpha: 1)) ? .destructive : .default, handler: { action in
            if (self.wantlistAddToButton.backgroundColor == UIColor(red: 255/255, green: 73/255, blue: 74/255, alpha: 1)) {
                self.wantlistAddToButton.backgroundColor = UIColor(red: 143/255, green: 143/255, blue: 143/255, alpha: 1)
            } else {
                self.wantlistAddToButton.backgroundColor = UIColor(red: 255/255, green: 73/255, blue: 74/255, alpha: 1)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    // MARK: - Discogs Request
    func getArtistImage(){
    let discogsArtistURL = DISCOGS_ARTIST_URL
    let artistId = album.artistsId ?? "108713"
    let url = discogsArtistURL + artistId +  DISCOGS_KEY_SECRET_FORMAT2
        
    Alamofire.request(url)
    .responseJSON { response in
        // check for errors
        guard response.result.error == nil else {
            // got an error in getting the data, need to handle it
            print("error calling GET on /todos/1")
            print(response.result.error!)
            return
        }
        
        // make sure we got some JSON since that's what we expect
        guard let artistInfoJsonArray = response.result.value as? [String: Any] else {
            print("didn't get todo object as JSON from API")
            if let error = response.result.error {
                print("Error: \(error)")
            }
            return
        }
        if let images = artistInfoJsonArray["images"] as? [[String: Any]] {
            if let uri = images[0]["uri"] as? String {
                self.artistImageUrl = uri
                let imageUrl = URL(string: uri)
                self.artistImageView.af_setImage(withURL: imageUrl!)
            } else {
                print("error image uri")
            }
        }
    }
    }
    
}
