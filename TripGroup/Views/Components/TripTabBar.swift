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
        HStack(spacing: 64.0) {
            ForEach(tabItems.indices) { index in
                VStack(spacing: 0.0) {
                    Image(systemName: tabItems[index].icon)
                    Text(tabItems[index].title)
                        .font(.caption)
                }
                .onTapGesture { selectedIndex = index }
                .foregroundColor(selectedIndex == index ? Color.white : Color.black)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.tripBackground)
        .cornerRadius(8.0)
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
