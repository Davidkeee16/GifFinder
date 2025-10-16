//
//  NetworkManager.swift
//  GifFinder
//
//  Created by David Puksanskis on 13/10/2025.
//

import Foundation

final class NetworkManager {
    
    // MARK: Properties

    static let shared = NetworkManager()
    private let apiKey = GiphyAPI.apiKey
    private let decoder = JSONDecoder()
    
    
    // MARK: Methods
    
    
    // MARK: Searching GIFs
    func searchGifs(with name: String, limit: Int = 15, offset: Int = 0 ) async throws -> GifPage {
        print("I'm in Network Manager")
        guard !apiKey.isEmpty else { throw NetworkError.wrongAPI }
        print("Succesfull API")
        var components = URLComponents(string: GiphyAPI.base + GiphyAPI.gifSearch)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "q", value: name),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "rating", value: GiphyDefaults.rating),
            URLQueryItem(name: "lang", value: GiphyDefaults.lang),
            URLQueryItem(name: "bundle", value: GiphyDefaults.bundle)
        ]
        
        guard let url = components?.url else { throw NetworkError.wrongURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.errorResponse }
        print("Response OK")
        do {
            let dto = try decoder.decode(GiphySearchResponse.self, from: data)
            return GifPage(items: dto.data, pagination: dto.pagination)
            
        } catch {
            print(String(data: data, encoding: .utf8) ?? "")
            throw NetworkError.invalidData
        }
    }
    
}
