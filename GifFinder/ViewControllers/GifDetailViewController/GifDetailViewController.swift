//
//  GifDetailViewController.swift
//  GifFinder
//
//  Created by David Puksanskis on 13/10/2025.
//

import UIKit

final class GifDetailViewController: UIViewController {
    
    private let gif: GifData
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let spinner = UIActivityIndicatorView(style: .large)
    
    init(gif: GifData) {
        self.gif = gif
        super.init(nibName: nil, bundle: nil)
        self.title = "Details"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GifDetailViewController {
    // MARK: setup constraints
    
    func setupConstraints() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = gif.title ?? "Untitled"
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    private func loadDownsizedGif() {
        guard let urlString = gif.images.downsized?.url, let url = URL(string: urlString) else { return }
        
        spinner.startAnimating()
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
               
                
                await MainActor.run {
                   
                }
            } catch {
                await MainActor.run { self.spinner.stopAnimating() }
            }
        }
    }
}
