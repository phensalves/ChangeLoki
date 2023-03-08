//
//  ContentViewTests.swift
//  ChangeLoki
//
//  Created by Pedro Alves on 07/03/2023.
//

import XCTest
import MapKit
@testable import ChangeLoki

class ContentViewTests: XCTestCase {
    
    var sut: ContentView!
    
    override func setUp() {
        super.setUp()
        sut = ContentView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testContentView_WhenInitialized_RegionIsSet() {
        // Given
        let expectedRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        // Then
        XCTAssertEqual(sut.region, expectedRegion)
    }
    
    func testContentView_WhenInitialized_AnnotationIsNil() {
        // Then
        XCTAssertNil(sut.annotation)
    }
    
    func testContentView_WhenInitialized_SearchQueryIsEmpty() {
        // Then
        XCTAssertTrue(sut.searchQuery.isEmpty)
    }
    
    func testContentView_WhenInitialized_SearchCoordinateIsNil() {
        // Then
        XCTAssertNil(sut.searchCoordinate)
    }
    
    func testContentView_WhenInitialized_CancellableIsNotNil() {
        // Then
        XCTAssertNotNil(sut.cancellable)
    }
    
    func testContentView_OnAppear_RequestAuthorizationIsCalled() {
        // Given
        let locationManagerMock = LocationManagerMock()
        sut.locationManager = locationManagerMock
        
        // When
        sut.onAppear()
        
        // Then
        XCTAssertTrue(locationManagerMock.requestAuthorizationCalled)
    }
    
    func testContentView_OnAppear_SinkIsCalledWithExpectedLocation() {
        // Given
        let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        let locationManagerMock = LocationManagerMock(location: expectedLocation)
        sut.locationManager = locationManagerMock
        
        // When
        sut.onAppear()
        
        // Then
        XCTAssertEqual(sut.annotation?.coordinate, expectedLocation.coordinate)
        XCTAssertEqual(sut.region.center, expectedLocation.coordinate)
        XCTAssertEqual(locationManagerMock.stopUpdatingLocationCallCount, 1)
    }
    
    func testContentView_DropPinButton_AddsAnnotationToMap() {
        // Given
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 37.7874, longitude: -122.4082)
        
        // When
        sut.dropPin()
        
        // Then
        XCTAssertEqual(sut.annotation?.coordinate, expectedCoordinate)
    }
    
    func testContentView_OnSearch_SetsRegionAndSearchCoordinate() {
        // Given
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 37.7874, longitude: -122.4082)
        
        // When
        sut.onSearch(expectedCoordinate)
        
        // Then
        XCTAssertEqual(sut.searchCoordinate, expectedCoordinate)
        XCTAssertEqual(sut.region.center, expectedCoordinate)
    }
    
    func testContentView_OnDismiss_SetsRegionWhenSearchCoordinateIsNotNil() {
        // Given
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 37.7874, longitude: -122.4082)
        sut.searchCoordinate = expectedCoordinate
        
        // When
        sut.onDismiss()
        
        // Then
        XCTAssertEqual(sut.region.center, expectedCoordinate)
    }
    
    func testContentView_OnDismiss_DoesNotSetRegionWhenSearchCoordinateIsNil() {
        // Given
        sut.searchCoordinate = nil
        let originalRegion = sut.region
        
        // When
        sut.onDismiss()
        
        // Then
        XCTAssertEqual(sut.region, originalRegion)
    }
    
    func testContentView_OnDismiss_ShowsAlertIfNeededWhenLocationManagerIsAuthorized() {
        // Given
    }
}
