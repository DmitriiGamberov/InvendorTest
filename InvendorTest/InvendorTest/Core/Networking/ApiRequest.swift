//
//  ApiRequest.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Foundation

protocol ApiRequest {
    associatedtype Body
    associatedtype Response: Decodable

    var path: String { get }
    var method: String { get }
    var headers: [String: String] { get }
    var body: Body? { get }

    func encodeBody() throws -> Data?
}

struct TokenRequest: ApiRequest {
    struct BodyData {
        let grant_type: String
        let client_id: String
        let client_secret: String
    }

    typealias Body = BodyData
    typealias Response = TokenResponse

    let path = "/connect/token"
    let method = "POST"
    let headers = ["Content-Type": "application/x-www-form-urlencoded"]
    let body: Body?

    init(clientId: String, clientSecret: String) {
        self.body = BodyData(grant_type: "client_credentials", client_id: clientId, client_secret: clientSecret)
    }

    func encodeBody() throws -> Data? {
        guard let body = body else { return nil }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: body.grant_type),
            URLQueryItem(name: "client_id", value: body.client_id),
            URLQueryItem(name: "client_secret", value: body.client_secret)
        ]
        return components.query?.data(using: .utf8)
    }
}

struct PostEntryRequest: ApiRequest {
    typealias Body = Coordinate
    typealias Response = EmptyResponse

    let entry: Coordinate
    var path: String { "/api/GPSEntries" }
    let method = "POST"
    let headers = ["Content-Type": "application/json"]
    var body: Coordinate? { entry }

    func encodeBody() throws -> Data? {
        guard let body = body else { return nil }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(body)
    }
}

struct PostBulkEntriesRequest: ApiRequest {
    typealias Body = [Coordinate]
    typealias Response = EmptyResponse

    let entries: [Coordinate]
    var path: String { "/api/GPSEntries/bulk" }
    let method = "POST"
    let headers = ["Content-Type": "application/json"]
    var body: [Coordinate]? { entries }

    func encodeBody() throws -> Data? {
        guard let body = body else { return nil }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(body)
    }
}

struct EmptyResponse: Decodable {}
