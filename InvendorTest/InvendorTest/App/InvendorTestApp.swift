//
//  InvendorTestApp.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import SwiftUI
import BackgroundTasks

@main
struct InvendorTestApp: App {
    private let container: AppDIContainer

    init() {
        self.container = AppDIContainer()
        container.backgroundTaskScheduler.registerBackgroundTask(with: container)
    }

    var body: some Scene {
        WindowGroup {
            container.makeTrackingView()
        }
    }
}
