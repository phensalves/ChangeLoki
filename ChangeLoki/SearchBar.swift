//
//  SearchBar.swift
//  ChangeLoki
//
//  Created by Pedro Alves on 06/03/2023.
//

import Foundation
import SwiftUI
import MapKit

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    var onSearch: (CLLocationCoordinate2D) -> Void

    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar

        init(_ parent: SearchBar) {
            self.parent = parent
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()

            let localSearchRequest = MKLocalSearch.Request()
            localSearchRequest.naturalLanguageQuery = searchBar.text
            let localSearch = MKLocalSearch(request: localSearchRequest)
            localSearch.start { (response, error) in
                guard let response = response, let mapItem = response.mapItems.first else { return }
                let coordinate = mapItem.placemark.coordinate
                self.parent.onSearch(coordinate)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search for location"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
