//
//  TripUser.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.

import Foundation

struct TripUser: Codable, Equatable {
    var name: String       // username
    var avatar_url: URL?  // profile image
    var groups: [String]
}

extension TripUser {
    static var userInfo: TripUser?
}
