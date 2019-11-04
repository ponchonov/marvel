//
//  Character.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import Foundation



struct Response: Codable {
    var code : Int
    var status: String
    var etag: String
    var data: DataResult
}

struct DataResult: Codable {
    var offset : Int
    var limit: Int
    var total: Int
    var count: Int
    var results : [Character]
}

struct Character: Codable {
    var id: Int
    var name: String
    var description: String
    var thumbnail: Thumbnail
    var comics: ComicData
}

struct Thumbnail: Codable {
    var path: URL
    
}

struct ComicData: Codable {
    var available: Int
    var collectionURI: String
    var items: [Comic]
}

struct Comic: Codable {
    var resourceURI : URL
    var name : String
}
