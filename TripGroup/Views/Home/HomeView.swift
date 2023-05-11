//
//  HomeView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var firebase: FirebaseViewModel
    let group = ["Group1", "Group2", "Group3"]
    @State var currentGroup: String = ""
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer()
                Button {
                    firebase.addGroup(groupName: "Group1")
                } label: {
                    Label("Add Group", systemImage: "plus.circle")
                        .labelStyle(.trailingIcon)
                        .tint(.tripBackground)
                }
            }.padding(.all, 16.0)
            Spacer()
            TripGroupView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirebaseViewModel())
    }
}
