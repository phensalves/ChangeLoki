//
//  LocationManager.swift
//  ChangeLoki
//
//  Created by Pedro Alves on 27/02/2023.
//

import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    private let locationSubject = PassthroughSubject<CLLocation?, Never>()
    var locationPublisher: AnyPublisher<CLLocation?, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    @Published var region = MKCoordinateRegion()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            startUpdatingLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        locationSubject.send(location)
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.region = region
        
        // Stop updating location after receiving the first location update
        stopUpdatingLocation()
    }
}
