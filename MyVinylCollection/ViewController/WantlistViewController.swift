//
//  WantlistViewController.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 04/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import AlamofireImage

class WantlistViewController: BaseViewController {

    var wantlistCollection: [Album]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func refreshAllViews(){
        
    }

    func refreshWantlistAlbumList(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        let typePredicate = NSPredicate(format: "albumInCollection = %@", "false")
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.predicate = typePredicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            wantlistCollection = try context.fetch(fetchRequest) as? [Album]
        } catch {
            print("Context could not send data")
        }
        refreshAllViews()
    }

}
