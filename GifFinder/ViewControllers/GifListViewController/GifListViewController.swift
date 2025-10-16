//
//  ViewController.swift
//  GifFinder
//
//  Created by David Puksanskis on 11/10/2025.
//

import UIKit
import Combine

final class GifListViewController: UIViewController {
    
    enum Section: Int, CaseIterable {
        case gifList
    }
    
    // MARK: Properties
    
    private let viewModel = GifViewModel()
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, GifData>!

    private lazy var collectionView = UICollectionView()
    
    private var overlaySpinner = UIActivityIndicatorView(style: .medium)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        searchBarSetup()
        setupCollectionView()
        configureDataSource()
        bind()
        
    }
}
// MARK: Methods

// MARK: CollectionView setup, delegate

extension GifListViewController: UICollectionViewDelegate {
   
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
        view.addSubview(collectionView)
        
        collectionView.register(GifCell.self, forCellWithReuseIdentifier: GifCell.reuseId)
        
        collectionView.delegate = self
        
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { fatalError() }
            switch section {
            case .gifList:
                return self.createGifListSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createGifListSection() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
                                          
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .absolute(140)),
            subitem: item,
            count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 8, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 12
        return section
    }
}
// MARK: Data Source
extension GifListViewController {
    
    // MARK: Observe
    private func bind() {
        viewModel.$gifs
            .receive(on: RunLoop.main)
            .sink { [weak self] gifs in
                guard let self else { return }
                var snapshot = NSDiffableDataSourceSnapshot<Section, GifData>()
                snapshot.appendSections([.gifList])
                snapshot.appendItems(gifs, toSection: .gifList)
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Configure Data Source
 
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, GifData>(collectionView: collectionView) { [weak self] collectionView, indexPath, gif in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.reuseId, for: indexPath) as! GifCell
            cell.configure(with: gif)
            
            return cell
        }
    }
}

// MARK: Search bar

extension GifListViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    private func searchBarSetup() {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search GIFs"
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        viewModel.query = searchController.searchBar.text ?? ""
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.query = ""
    }
    
}

// MARK: Spinner

extension GifListViewController {
    
    
}



// MARK: Simulator

import SwiftUI

struct GifListVCProvider: PreviewProvider {
    
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
        
    }
    struct ContainerView: UIViewControllerRepresentable {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<GifListVCProvider.ContainerView>) -> GifListViewController {
            return GifListViewController()
        }
        func updateUIViewController(_ uiViewController: GifListVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<GifListVCProvider.ContainerView>) {
        }
    }
}
