//
//  NetworkError.swift
//  GifFinder
//
//  Created by David Puksanskis on 13/10/2025.
//

import Foundation

enum NetworkError: String, Error {
    
    case wrongAPI = "Invalid API"
    case wrongURL  = "Invalid URL"
    case errorResponse = "Invalid response from the server"
    case invalidData = "Cannot get data from the server"
}
