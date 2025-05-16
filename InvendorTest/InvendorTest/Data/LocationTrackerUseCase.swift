//
//  LocationTrackerUseCase.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Foundation

protocol LocationTrackerUseCase {
    func startTracking()
    func stopTracking()
}

final class LocationTrackerUseCaseImplementation: LocationTrackerUseCase {
    private let locationService: LocationService
    private let storage: CoordinateStorage
    private let sender: CoordinateSender
    private var timer: Timer?

    init(locationService: LocationService, storage: CoordinateStorage, sender: CoordinateSender) {
        self.locationService = locationService
        self.storage = storage
        self.sender = sender
    }

    func startTracking() {
        locationService.startUpdating { _ in }
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            guard let location = self.locationService.currentLocation else { return }
            let coord = Coordinate(createdDateTime: Date(), latitude: location.latitude, longitude: location.longitude)
            self.sendOrSave(coord)
        }
    }

    func stopTracking() {
        timer?.invalidate()
        locationService.stopUpdating()
    }

    private func sendOrSave(_ coordinate: Coordinate) {
        sender.send([coordinate]) { success in
            if !success {
                self.storage.append(coordinate)
            }
        }
    }
}
