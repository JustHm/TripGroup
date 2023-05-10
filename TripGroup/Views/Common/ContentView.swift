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
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                TripCalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }.tag(1)
                TripMapView()
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }.tag(2)
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }.tag(3)
            }
            .tint(.white)
            .onAppear {
                UITabBar.appearance().backgroundColor = UIColor(.tripBackground)
            }
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
