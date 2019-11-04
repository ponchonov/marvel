//
//  Comics.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import Foundation

struct ResponseComics: Codable {
    var code : Int
    var status: String
    var etag: String
    var data: DataResultComics
}

struct DataResultComics: Codable {
    var offset : Int
    var limit: Int
    var total: Int
    var count: Int
    var results : [Comic]
}

struct ComicData: Codable {
    var available: Int
    var collectionURI: String
    var items: [Comic]
}

struct Comic: Codable {
    var id : Int
    var title : String
    var thumbnail: Thumbnail
}
