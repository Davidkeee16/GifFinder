//
//  Gifs.swift
//  GifFinder
//
//  Created by David Puksanskis on 11/10/2025.
//

import Foundation

// MARK: Giphy Search response
struct GiphySearchResponse: Decodable {
    let data: [GifData]
    let pagination: Pagination
}

// MARK: GIF data
struct GifData: Decodable, Hashable, Identifiable {
    let type: String?
    let id: String
    let title: String?
    let importDatetime: String?
    let images: Images
    let altText: String?
    
    static func == (lhs: GifData, rhs: GifData) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case title
        case importDatetime = "import_datetime"
        case images
        case altText = "alt_text"
    }
}
// MARK: GIF images
struct Images: Decodable {
    let fixedHeightSmall: Rendition?
    let fixedWidthSmall: Rendition?
    let downsized: Rendition?
    let previewGif: Rendition?
    
    enum CodingKeys: String, CodingKey {
        case fixedHeightSmall = "fixed_height_small"
        case fixedWidthSmall = "fixed_width_small"
        case downsized
        case previewGif
    }
}
// MARK: Rendition
struct Rendition: Decodable {
    let height: String?
    let width: String?
    let size: String?
    let url: String?
}

// MARK: Pagination
struct Pagination: Decodable {
    let totalCount: Int
    let count: Int
    let offset: Int
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case offset
    }
}
struct GifPage {
    let items: [GifData]
    let pagination: Pagination
}


// MARK: GifData extension
extension GifData {
    var previewURL: URL? {
        let s = images.fixedHeightSmall?.url
        ?? images.fixedWidthSmall?.url
        ?? images.downsized?.url
        ?? images.previewGif?.url
        return s.flatMap(URL.init(string:))
    }
}
