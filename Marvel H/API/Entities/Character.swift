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
}

struct Thumbnail: Codable {
    var path: URL
    var ext: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}


