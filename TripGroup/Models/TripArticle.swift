//
//  TripArticle.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI

struct TripArticle {
    let writer: TripUser
    let description: String
    let images: [String]
    let member: [String]
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case writer, description, images, member, date
        
    }
}
