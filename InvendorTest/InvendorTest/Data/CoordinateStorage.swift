//
//  CoordinateStorage.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Foundation

protocol CoordinateStorage {
    func append(_ coordinate: Coordinate)
    func fetchAll() -> [Coordinate]
    func deleteAll()
    func hasPendingData() -> Bool
}

final class FileCoordinateStorage: CoordinateStorage {
    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        fileURL = dir.appendingPathComponent("unsent_coordinates.json")
    }

    func append(_ coordinate: Coordinate) {
        var existing = fetchAll()
        existing.append(coordinate)
        save(existing)
    }

    func fetchAll() -> [Coordinate] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([Coordinate].self, from: data)) ?? []
    }

    func deleteAll() {
        try? FileManager.default.removeItem(at: fileURL)
    }

    func hasPendingData() -> Bool {
        FileManager.default.fileExists(atPath: fileURL.path)
    }

    private func save(_ coordinates: [Coordinate]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(coordinates) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
