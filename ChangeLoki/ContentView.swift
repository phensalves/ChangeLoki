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
    @State private var showingSearch = false
    @State private var searchQuery = ""
    @State private var searchCoordinate: CLLocationCoordinate2D?
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: [annotation].compactMap { $0 }) { annotation in
                MapMarker(coordinate: annotation.coordinate)
            }
            VStack {
                SearchBar(text: $searchQuery, onSearch: { coordinates in
                    searchCoordinate = coordinates
                    region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                    if locationManager.locationManager.authorizationStatus == .authorizedWhenInUse && !showingAlert {
                        showingAlert = true
                        let alert = UIAlertController(title: "Location Updated", message: "The app will now use the new location for searching.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                            windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }
                    showingSearch = false
                })
                Spacer()
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingSearch, onDismiss: {
                if let coordinate = searchCoordinate {
                    region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                    if locationManager.locationManager.authorizationStatus == .authorizedWhenInUse && !showingAlert {
                        showingAlert = true
                        let alert = UIAlertController(title: "Location Updated", message: "The app will now use the new location for searching.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            if let rootViewController = windowScene.windows.first?.rootViewController {
                                rootViewController.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }, content: {
                SearchBar(text: $searchQuery) { coordinates in
                    searchCoordinate = coordinates
                    showingSearch = false
                }
            })
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
