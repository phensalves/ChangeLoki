//
//  MapView.swift
//  ChangeLoki
//
//  Created by Pedro Alves on 27/02/2023.
//

import SwiftUI
import MapKit

extension MKPointAnnotation: Identifiable {}

struct MapView: UIViewRepresentable {
    @StateObject var coordinator = MapViewCoordinator(mapView: MKMapView())

    func makeUIView(context: Context) -> MKMapView {
        return coordinator.mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
}
