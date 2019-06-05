//
//  DataService.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 05/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import SwiftyJSON

class DataService {
    
    
    static let dataService = DataService()

    private(set) var ALBUM_FROM_DISCOGS = ""
    private(set) var YEAR_FROM_DISCOGS = ""
    
    static func searchBarCodeAPI(codeNumber: String) {
        
        // The URL we will use to get out album data from Discogs
        let discogsURL = "\(DISCOGS_AUTH_SEARCH_URL)\(codeNumber)&?barcode&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"
        
        Alamofire.request(discogsURL)
            .responseJSON {
                response in
                
                var json = JSON(response.result.value!)
                
                let albumArtistTitle = "\(json["results"][0]["title"])"
                let albumYear = "\(json["results"][0]["year"])"
                
                self.dataService.ALBUM_FROM_DISCOGS = albumArtistTitle
                self.dataService.YEAR_FROM_DISCOGS = albumYear
                
                // Post a notification to let AlbumDetailsViewController know we have some data.
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AlbumNotification"), object: nil)
                
        }
        
    }
    
    static func getUserCollection() {
        
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
                        } else {
                            print("No date added")
                        }
// Album Id
                        if let id = release["id"] as? Int {
                            album?.id = String(id)
                        } else {
                            print("No album Id")
                        }
                            // 
// Gp : Basic Info
                        if let info = release["basic_information"] as? [String: Any]{
// Album name
                            if let title = info["title"] as? String {
                                album?.albumName = title
                            } else {
                                print("No title")
                            }
// Gp Artists
                            if let artist = info["artists"] as? [String: Any]{
                                if let artistName = artist["name"] as? String {
                                    album?.artistsName = artistName
                                } else {
                                    print("no artist name")
                                }
                                if let artistId = artist["id"] as? Int {
                                    album?.artistsId = String(artistId)
                                } else {
                                    print("no artist id")
                                }
                                } else {
                                    print("no artists")
                                }
// Gp Label
                            if let labels = info["labels"] as? [String: Any]{
                                if let labelName = labels["name"] as? String {
                                    album?.labelName = labelName
                                } else {
                                    print("No label name")
                                }
                            } else {
                                print("No Labels")
                            }
// Album year
                            if let year = info["year"] as? Int {
                                album?.year = String(year)
                            } else {
                                print("No year")
                            }
// Image album
                            if let image = info["cover_image"] as? String {
                                album?.image = image
                            } else {
                                print("No Cover image")
                            }
// Small Image album
                            if let imageSmall = info["thumb"] as? String {
                                album?.imageSmall = imageSmall
                            } else {
                                print("No small image")
                            }
// Gp : Format:
                            if let formats = info["formats"] as? [String: Any]{
                                if let formatName = formats["name"] as? String {
                                    album?.formatsName = formatName
                                } else {
                                    print("No Format name")
                                }
                            } else {
                                print("No Formats")
                            }
                            // Track url
                            if let tracksURL = info["resource_url"] as? String {
                                album?.tracksURL = tracksURL
                            } else {
                                print("No tracksURL")
                            }
                        } else {
                            print("no basic info")
                        }
                    }
                }
                

    }
        do {
            try context.save()
        } catch {
            print("context could not save data")
        }
    }
}
