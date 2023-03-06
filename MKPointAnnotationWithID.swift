//
//  MKPointAnnotationWithID.swift
//  ChangeLoki
//
//  Created by Pedro Alves on 27/02/2023.
//

import MapKit

class MKPointAnnotationWithID: MKPointAnnotation {
    override init() {
        super.init()
    }
    var id = UUID()
}
