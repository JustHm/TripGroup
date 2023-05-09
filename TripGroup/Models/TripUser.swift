//
//  TripUser.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import Foundation

struct TripUser: Identifiable, Codable, Equatable {
    let id: String             // UID
    let name: String       // username
    let email: String      // email
    let avatar_url: URL?  // profile image
}
