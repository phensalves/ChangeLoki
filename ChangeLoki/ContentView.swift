//
//  ContentView.swift
//  ChangeLoki
//
//  Created by Pedro Alves on 27/02/2023.
//
import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var annotation: MKPointAnnotation?

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [annotation].compactMap { $0 }) { annotation in
            MapMarker(coordinate: annotation.coordinate)
        }
        .onAppear {
            locationManager.requestAuthorization()
        }
        .onReceive(locationManager.locationPublisher) { location in
            if let location = location {
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            }
        }
        .overlay(Button("Drop Pin") {
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = region.center
            annotation = newAnnotation

            let location = CLLocation(latitude: newAnnotation.coordinate.latitude, longitude: newAnnotation.coordinate.longitude)
            print(location)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .clipShape(Circle())
        .padding(.trailing)
        , alignment: .bottomTrailing)
    }
}
