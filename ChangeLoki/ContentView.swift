//
//  ContentView.swift
//  ChangeLoki
//
//  Created by Pedro Alves on 27/02/2023.
//
import SwiftUI
import MapKit
import CoreLocation
import Combine

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State private var annotation: MKPointAnnotation?
    @State private var showingSearch = false
    @State private var searchQuery = ""
    @State private var searchCoordinate: CLLocationCoordinate2D?
    @State private var showingAlert = false
    @State private var cancellable: AnyCancellable?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: [annotation].compactMap { $0 }) { annotation in
                MapMarker(coordinate: annotation.coordinate)
            }
            VStack {
                SearchBar(text: $searchQuery, onSearch: onSearch)
                Spacer()
            }
            .padding(.horizontal)
            .sheet(isPresented: $showingSearch, onDismiss: onDismiss, content: {
                SearchBar(text: $searchQuery, onSearch: onSearch)
            })
        }
        .onAppear {
            locationManager.requestAuthorization()
            cancellable = locationManager.$location
                .compactMap { $0 }
                .sink { [weak self] location in
                    guard let self = self else { return }
                    self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                    self.addAnnotation(for: location)
                    self.locationManager.stopUpdatingLocation()
                }
        }
        .overlay(dropPinButton, alignment: .bottomTrailing)
    }
    
    private var dropPinButton: some View {
        Button(action: dropPin) {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .frame(width: 44, height: 44)
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .clipShape(Circle())
        .padding(.trailing)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
    }
    
    private func dropPin() {
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = region.center
        annotation = newAnnotation
    }
    
    private func onSearch(_ coordinates: CLLocationCoordinate2D) {
        searchCoordinate = coordinates
        region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        showAlertIfNeeded()
        showingSearch = false
    }
    
    private func onDismiss() {
        if let coordinate = searchCoordinate {
            region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            showAlertIfNeeded()
        }
    }
}
