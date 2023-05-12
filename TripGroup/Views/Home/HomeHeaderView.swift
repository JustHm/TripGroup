//
//  HomeHeader.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/12.
//

import SwiftUI

struct HomeHeaderView: View {
    @State var groupTitle: String?
    var groups: [String] = ["group1", "group2"]
    @Binding var isAddGroupTapped: Bool
    var body: some View {
        HStack(alignment: .center) {
            Spacer()

            Menu {
                ForEach(groups, id: \.self) { element in
                    Button(element) {
                        groupTitle = element
                    }
                }
            } label: {
                Label("", systemImage: "chevron.down.circle")
            }
            
            Text(groupTitle ?? "Create group")
                .font(.title)
                .fontWeight(.bold)
                .scaledToFit()
            
            Spacer()
            
            Button {
                isAddGroupTapped.toggle()
            } label: {
                Image(systemName: "plus.circle")
                    .tint(.tripBackground)
            }
        }
        .padding()
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView(isAddGroupTapped: .constant(false))
    }
}
