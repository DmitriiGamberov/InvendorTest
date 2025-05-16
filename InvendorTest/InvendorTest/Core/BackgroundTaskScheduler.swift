//
//  BackgroundTaskScheduler.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import BackgroundTasks
import Foundation

protocol RetryTaskScheduling {
    func scheduleRetry()
    func registerBackgroundTask(with container: AppDIContainer)
}

final class BackgroundTaskScheduler: RetryTaskScheduling {
    private let identifier = "com.gamberov.inverndortest.sendpending"
    private var container: AppDIContainer?

    func registerBackgroundTask(with container: AppDIContainer) {
        self.container = container
        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: nil) { task in
            self.handleBackgroundTask(task: task as! BGProcessingTask)
        }
    }

    func scheduleRetry() {
        let request = BGProcessingTaskRequest(identifier: identifier)
        request.requiresNetworkConnectivity = true
        request.earliestBeginDate = Date(timeIntervalSinceNow: 600)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to schedule background task: \(error)")
        }
    }

    private func handleBackgroundTask(task: BGProcessingTask) {
        guard let sendUseCase = container?.makeSendCoordinatesUseCase() else {
            task.setTaskCompleted(success: false)
            return
        }

        task.expirationHandler = {
            print("Background task expired")
        }

        sendUseCase.sendPendingCoordinates()
        scheduleRetry()
        task.setTaskCompleted(success: true)
    }
}
