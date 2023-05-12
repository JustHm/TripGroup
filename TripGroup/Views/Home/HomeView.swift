//
//  HomeView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var storage: StorageViewModel
    @State var currentGroup: String?
    @Binding var isAddGroupTapped: Bool
    var body: some View {
        VStack {
            HomeHeaderView(groupTitle: nil,
                           groups: storage.userInfo?.groups ?? ["a", "b"],
                           isAddGroupTapped: $isAddGroupTapped
            )
            
            if let userInfo = storage.userInfo, userInfo.groups.isEmpty {
                TripGroupView()
            } else {
                TripGroupView()
            }
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isAddGroupTapped: .constant(false))
            .environmentObject(StorageViewModel())
    }
}
