//
//  MapViewCoordinator.swift
//  ChangeLoki
//
//  Created by Pedro Alves on 27/02/2023.
//

import MapKit


class MapViewCoordinator: NSObject, MKMapViewDelegate, ObservableObject {
    @Published var annotations = [MKPointAnnotationWithID]()

    var mapView: MKMapView

    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        self.mapView.delegate = self
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "AnnotationView")
        annotationView.canShowCallout = true
        return annotationView
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        let center = mapView.centerCoordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotations.append(MKPointAnnotationWithID(coordinate: annotation.coordinate))
    }
}
