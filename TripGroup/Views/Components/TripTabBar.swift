//
//  TripTabBar.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI

struct TripTabBar: View {
    @State var tabItems: [TabList]
    @Binding var selectedIndex: Int
    var body: some View {
        Text("Empty")
    }
}

struct TripTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TripTabBar(tabItems: [
        TabList(title: "Home", icon: "house"),
        TabList(title: "Map", icon: "map"),
        TabList(title: "Calendar", icon: "calendar"),
        TabList(title: "Settings", icon: "gear")
        ], selectedIndex: .constant(0))
    }
}
