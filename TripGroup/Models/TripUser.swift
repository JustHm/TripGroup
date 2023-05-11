//
//  TripUser.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import Foundation

struct TripUser: Codable, Equatable {
    let name: String       // username
    let avatar_url: URL?  // profile image
    let groups: [String]
}
