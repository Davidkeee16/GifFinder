//
//  ViewModel.swift
//  GifFinder
//
//  Created by David Puksanskis on 13/10/2025.
//

import Foundation
import Combine



final class GifViewModel {
    // MARK: Properties
    @Published var gifs: [GifData] = []
   
    // MARK: Methods
    // MARK: Get GIFs list
    
    func fetchGifs() {
        Task {
            do {
                let gifs = try await NetworkManager.shared.searchGifs(with: "sun")
                self.gifs = gifs
            } catch {
                if let error = error as? NetworkError {
                    print(error)
                }
            }
        }
    }
}
