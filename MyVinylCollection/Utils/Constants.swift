//
//  Constants.swift
//  MyVinylCollection
//
//  Created by Antoine Proux on 05/06/2019.
//  Copyright © 2019 Antoine Proux. All rights reserved.
//

import Foundation
import UIKit

//MARK: -DISCOGS CONSTANTS
let DISCOGS_KEY = "GfQTpbKMrPYFtauHAsge"
let DISCOGS_SECRET = "hvoGadSLuvAorHpbiZVKVpMynHEqMBsl"
let DISCOGS_REQUEST_TOKEN = "https://api.discogs.com/oauth/request_token"
let DISCOGS_AUTHORIZE_URL = "https://www.discogs.com/oauth/authorize"
let DISCOGS_ACCESS_TOKEN_URL = "https://api.discogs.com/oauth/access_token"
// DISCOGS CONNECTION
let DISCOGS_AUTH_URL = "https://api.discogs.com/database/"
// SEARCH QUERY
let DISCOGS_AUTH_SEARCH_URL = "https://api.discogs.com/database/search?q="
// GET USER COLLECTION
let DISCOGS_USER_COLLECTION_URL = "https://api.discogs.com/users/nioto/collection/folders/0/releases?sort=added&key=\(DISCOGS_KEY)&secret=\(DISCOGS_SECRET)"

//
