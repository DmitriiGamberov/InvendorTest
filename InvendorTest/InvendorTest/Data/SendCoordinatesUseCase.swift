//
//  SendCoordinatesUseCase.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Foundation

protocol SendCoordinatesUseCase {
    func sendPendingCoordinates()
}

final class SendCoordinatesUseCaseImplementation: SendCoordinatesUseCase {
    private let storage: CoordinateStorage
    private let sender: CoordinateSender

    init(storage: CoordinateStorage, sender: CoordinateSender) {
        self.storage = storage
        self.sender = sender
    }

    func sendPendingCoordinates() {
        let coords = storage.fetchAll()
        guard !coords.isEmpty else { return }

        sender.send(coords) { success in
            if success {
                self.storage.deleteAll()
            } 
        }
    }
}
