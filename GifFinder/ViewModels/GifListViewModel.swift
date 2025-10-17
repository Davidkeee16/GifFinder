//
//  ViewModel.swift
//  GifFinder
//
//  Created by David Puksanskis on 13/10/2025.
//

import Foundation
import Combine



final class GifViewModel {
    
    // MARK: Input
    @Published var query: String = ""
    
    // MARK: Output
    
    @Published private(set) var gifs: [GifData] = []
    @Published private(set) var isLoading = false
    @Published private(set) var isLoadingMore = false
    @Published private(set) var error: NetworkError?
    
    
    private var bag = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?
    
    
    // MARK: Pagination
    private var currentQuery: String = ""
    private var offset: Int = 0
    private var limit: Int = 10
    private var totalCount: Int = .max
    
    private var canLoadMore: Bool {
        offset < totalCount
    }
    private var seenIDs = Set<String>()
    
    init() {
        bindSearch()
    }
    
    // MARK: Methods
    // MARK: Get GIFs list
    
    
    private func bindSearch() {
        $query
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .removeDuplicates()
            .debounce(for: .milliseconds(350), scheduler: RunLoop.main)
            .sink { [weak self] text in
                     self?.startNewSearch(for: text)
            }
            .store(in: &bag)
    }
    
    private func startNewSearch(for text: String) {
        
        searchTask?.cancel()
        
        searchTask = Task { [weak self] in
            guard let self else { return }
            
            currentQuery = text.isEmpty ? "trending" : text
            offset = 0
            totalCount = .max
            seenIDs.removeAll()
            
            await MainActor.run {
                self.isLoading = true
                self.isLoadingMore = false
                self.error = nil
                self.gifs = []
            }
            
            do {
                
                let result = try await NetworkManager.shared.searchGifs(with: currentQuery, limit: limit, offset: offset)
                
                if Task.isCancelled { return }
                
                await MainActor.run {
                    
                    self.totalCount = result.pagination.totalCount
                    self.offset = result.pagination.offset + result.pagination.count
                    self.isLoading = false
                    self.appendUnique(result.items)
                    
                    
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.error = error as? NetworkError ?? .invalidData
                }
            }
        }
    }
    
    func loadNextPageIfNeeded(visibleIndex: Int) {
        guard canLoadMore, !isLoading, !isLoadingMore else { return }
        
        if visibleIndex >= gifs.count - 10 {
            loadMore()
        }
    }
    private func loadMore() {
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            
            await MainActor.run { self.isLoadingMore = true }
            
            do {
                let page = try await NetworkManager.shared.searchGifs(with: currentQuery, limit: limit, offset: offset)
                
                await MainActor.run {
                    
                    self.totalCount = page.pagination.totalCount
                    self.offset = page.pagination.offset + page.pagination.count
                    self.isLoadingMore = false
                    self.appendUnique(page.items)
                }
            } catch {
                await MainActor.run {
                    self.isLoadingMore = false
                    self.error = error as? NetworkError ?? .invalidData
                }
            }
        }
    }
    func appendUnique(_ newItems: [GifData]) {
        let unique = newItems.filter { self.seenIDs.insert($0.id).inserted }
        self.gifs.append(contentsOf: unique)
    }
    
    deinit { searchTask?.cancel() }
    
    
}
