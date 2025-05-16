//
//  ApiClient.swift
//  InvendorTest
//
//  Created by Dmitrii Gamberov on 16.05.2025.
//

import Foundation

protocol ApiClient {
    func authenticateIfNeeded() async throws
    func postEntry(_ entry: Coordinate) async throws
    func postBulkEntries(_ entries: [Coordinate]) async throws
}

struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}

final class ApiClientImplementation: ApiClient {
    private let baseURL = URL(string: "https://demo-api.invendor.com")!
    private let clientId = "test-app"
    private let clientSecret = "388D45FA-B36B-4988-BA59-B187D329C207"
    
    private var accessToken: String?
    private var tokenExpiry: Date?
    
    func authenticateIfNeeded() async throws {
        let now = Date()
        if let expiry = tokenExpiry, accessToken != nil, expiry > now {
            return
        }

        let tokenRequest = TokenRequest(clientId: clientId, clientSecret: clientSecret)
        let tokenResponse: TokenResponse = try await send(request: tokenRequest)
        self.accessToken = tokenResponse.access_token
        self.tokenExpiry = Date().addingTimeInterval(TimeInterval(tokenResponse.expires_in))
    }

    func postEntry(_ entry: Coordinate) async throws {
        try await authenticateIfNeeded()
       _ = try await send(request: PostEntryRequest(entry: entry))
    }

    func postBulkEntries(_ entries: [Coordinate]) async throws {
        try await authenticateIfNeeded()
       _ = try await send(request: PostBulkEntriesRequest(entries: entries))
    }

    private func send<R: ApiRequest>(request: R) async throws -> R.Response {
        let url = baseURL.appendingPathComponent(request.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        request.headers.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        if let data = try request.encodeBody() {
            urlRequest.httpBody = data
        }

        if let token = accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        if R.Response.self == EmptyResponse.self {
            return EmptyResponse() as! R.Response
        }

        return try JSONDecoder().decode(R.Response.self, from: data)
    }
}
