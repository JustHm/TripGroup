//
//  TripGroup.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/11.
//

import Foundation

struct TripGroup: Codable {
    let name: String
    let members: [Member]
    
    enum CodingKeys: String, CodingKey {
        case name, members
    }
}

struct Member: Codable {
    let uid: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case uid, name
    }
}

