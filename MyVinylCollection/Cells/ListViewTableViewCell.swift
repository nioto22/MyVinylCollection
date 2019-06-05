//
//  ListViewTableViewCell.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 04/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var albumPictureImageView: UIImageView!
    @IBOutlet weak var artistAlbumLabel: UILabel!
    @IBOutlet weak var formatAlbumLabel: UILabel!
    @IBOutlet weak var labelAlbumLabel: UILabel!
    @IBOutlet weak var yearAlbumLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
