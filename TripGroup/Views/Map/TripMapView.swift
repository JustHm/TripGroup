//
//  TripMapView.swift
//  TripGroup
//
//  Created by 안정흠 on 2023/05/09.
//

import SwiftUI
import MapKit

struct TripMapView: View {
    @EnvironmentObject var storage: StorageViewModel
    @Binding var isAddGroupTapped: Bool
    var body: some View {
        VStack {
            HomeHeaderView(groupTitle: nil,
                           groups: storage.userInfo?.groups ?? ["a", "b"],
                           isAddGroupTapped: .constant(false)
                           )
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), latitudinalMeters: 250.0, longitudinalMeters: 250.0)))
        }
    }
}

struct TripMapView_Previews: PreviewProvider {
    static var previews: some View {
        TripMapView(isAddGroupTapped: .constant(false))
            .environmentObject(StorageViewModel())
    }
}
