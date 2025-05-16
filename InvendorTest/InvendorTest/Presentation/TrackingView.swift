//
//  TrackingView.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import SwiftUI

struct TrackingView: View {
    @StateObject var viewModel: TrackingViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.isTracking ? "Tracking" : "Not tracking")
                .font(.title)

            Button(viewModel.isTracking ? "Stop" : "Start") {
                viewModel.toggleTracking()
            }
            .padding()
            .background(viewModel.isTracking ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }

}
