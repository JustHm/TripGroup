//
//  TabBarView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State var tabbarItems: [String]
    @Binding var selectedIndex: Int
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(tabbarItems.indices, id: \.self) { index in
                        
                        Text(tabbarItems[index])
                            .font(.subheadline)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .foregroundColor(selectedIndex == index ? .white : .black)
                            .background(Capsule().foregroundColor(selectedIndex == index ? .purple : .clear))
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = index
                                }
                            }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(25)
            
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(tabbarItems: ["a", "b", "c"], selectedIndex: .constant(0))
    }
}
