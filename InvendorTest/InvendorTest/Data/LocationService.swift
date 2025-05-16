//
//  LocationService.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private(set) var currentLocation: CLLocationCoordinate2D?
    private var onUpdate: ((CLLocationCoordinate2D) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func startUpdating(_ handler: @escaping (CLLocationCoordinate2D) -> Void) {
        self.onUpdate = handler
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        currentLocation = latest.coordinate
        onUpdate?(latest.coordinate)
    }
}
