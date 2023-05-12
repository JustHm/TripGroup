//
//  TripGroupView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/10.
//

import SwiftUI

struct TripGroupView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(pinnedViews: .sectionHeaders) {
                Section("Header1") {
                    Text("HI")
                    Text("HI")
                }
                Section("Header2") {
                    Text("HI")
                    Text("HI")
                }
                Section("Header3") {
                    Text("HI")
                    Text("HI")
                }
                Section("Header4") {
                    Text("HI")
                    Text("HI")
                }
                Section("Header5") {
                    Text("HI")
                    Text("HI")
                }
                Section("Header6") {
                    Text("HI")
                    Text("HI")
                }
                Section("Header7") {
                    Text("HI")
                    Text("HI")
                }
            }
        }
        .font(.largeTitle)
    }
}

struct TripGroupView_Previews: PreviewProvider {
    static var previews: some View {
        TripGroupView()
    }
}
