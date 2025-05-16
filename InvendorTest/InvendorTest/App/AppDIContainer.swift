//
//  AppDIContainer.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Foundation
import SwiftUI

final class AppDIContainer {
    let locationService: LocationService
    let storage: CoordinateStorage
    let networkMonitor: NetworkStatusProvider
    let apiClient: ApiClient
    let sender: CoordinateSender
    let backgroundTaskScheduler: RetryTaskScheduling

    init() {
        self.locationService = LocationService()
        self.storage = FileCoordinateStorage()
        self.networkMonitor = NetworkMonitor()
        self.apiClient = ApiClientImplementation()
        self.sender = CoordinateSender(apiClient: apiClient)
        self.backgroundTaskScheduler = BackgroundTaskScheduler()
    }

    func makeTrackerUseCase() -> LocationTrackerUseCase {
        LocationTrackerUseCaseImplementation(
            locationService: locationService,
            storage: storage,
            sender: sender
        )
    }

    func makeSendCoordinatesUseCase() -> SendCoordinatesUseCase {
        SendCoordinatesUseCaseImplementation(
            storage: storage,
            sender: sender
        )
    }

    func makeTrackingViewModel() -> TrackingViewModel {
        TrackingViewModel(
            trackerUseCase: makeTrackerUseCase(),
            senderUseCase: makeSendCoordinatesUseCase()
        )
    }
    
    func makeTrackingView() -> TrackingView {
        TrackingView(viewModel: self.makeTrackingViewModel())
    }
}
