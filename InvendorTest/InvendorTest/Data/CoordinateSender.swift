//
//  CoordinateSender.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Foundation

final class CoordinateSender {
    private let apiClient: ApiClient

    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func send(_ coordinates: [Coordinate], completion: @escaping (Bool) -> Void) {
        Task {
            do {
                if coordinates.count == 1 {
                    try await apiClient.postEntry(coordinates[0])
                } else {
                    try await apiClient.postBulkEntries(coordinates)
                }

                completion(true)
            } catch {
                print("Failed to send coordinates: \(error)")
                completion(false)
            }
        }
    }
}
