//
//  InitialView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/08.
//

import SwiftUI

struct InitialView: View {
    var body: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView()
    }
}
