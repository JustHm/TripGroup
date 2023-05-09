//
//  ContentView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct ContentView: View {
    var tabItems = [
        TabList(title: "Home", icon: "house"),
        TabList(title: "Map", icon: "map"),
        TabList(title: "Calendar", icon: "calendar"),
        TabList(title: "Settings", icon: "gear")
        ]
    @State var selectedIndex = 0
    var body: some View {
        VStack {
            switch selectedIndex {
            case 0:
                HomeView()
            case 1:
                Text("Calendar")
            case 2:
                Text("Map")
            default:
                SettingsView()
                    .environmentObject(AuthViewModel())
            }
            
            Spacer()
            TripTabBar(tabItems: tabItems, selectedIndex: $selectedIndex)
                .ignoresSafeArea(edges: .bottom)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TabList: Identifiable {
    var id: UUID = UUID()
    let title: String
    let icon: String
}
