//
//  TraillingIconLabel.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI

struct TraillingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TraillingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
