//
//  TripGroupApp.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI
import FirebaseCore

@main
struct TripGroupApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            InitialView()
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
