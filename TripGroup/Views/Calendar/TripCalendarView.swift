//
//  TripCalendarView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI

struct TripCalendarView: View {
    @EnvironmentObject var storage: StorageViewModel
    @Binding var isAddGroupTapped: Bool
    @State private var date: Date = Date()
    var body: some View {
        VStack {
            HomeHeaderView(groupTitle: nil,
                           groups: storage.userInfo?.groups ?? ["a", "b"],
                           isAddGroupTapped: .constant(false)
                           )
            
        }
    }
}

struct TripCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        TripCalendarView(isAddGroupTapped: .constant(false))
            .environmentObject(StorageViewModel())
    }
}
