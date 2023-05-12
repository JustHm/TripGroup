//
//  LoadView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/12.
//

import SwiftUI

struct LoadView: View {
    var body: some View {
        VStack {
            LottieView(name: "car-ignite-animation", mode: .loop)
        }
    }
}

struct LoadView_Previews: PreviewProvider {
    static var previews: some View {
        LoadView()
    }
}
