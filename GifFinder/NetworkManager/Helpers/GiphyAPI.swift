//
//  GiphyAPI.swift
//  GifFinder
//
//  Created by David Puksanskis on 13/10/2025.
//

import Foundation

// MARK: URL base and endpoints

enum GiphyAPI {
    
    static let base = "https://api.giphy.com/v1"
    static let gifSearch = "/gifs/search"
    static var apiKey: String {
        Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    }
    
}
