//
//  TrackingViewModel.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Foundation

final class TrackingViewModel: ObservableObject {
    @Published var isTracking = false

    private let trackerUseCase: LocationTrackerUseCase
    private let senderUseCase: SendCoordinatesUseCase

    init(trackerUseCase: LocationTrackerUseCase, senderUseCase: SendCoordinatesUseCase) {
        self.trackerUseCase = trackerUseCase
        self.senderUseCase = senderUseCase
    }

    func toggleTracking() {
        isTracking.toggle()
        isTracking ? trackerUseCase.startTracking() : stopAndSend()
    }

    private func stopAndSend() {
        trackerUseCase.stopTracking()
        senderUseCase.sendPendingCoordinates()
    }
}
