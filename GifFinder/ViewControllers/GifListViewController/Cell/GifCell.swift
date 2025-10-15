//
//  GifCell.swift
//  GifFinder
//
//  Created by David Puksanskis on 14/10/2025.
//

import UIKit

class GifCell: UICollectionViewCell, SelfConfigureCell {
    
    // MARK: Properties
    
    static var reuseId = "gifCell"
    
    let gifImage = UIImageView()
    
    
    // MARK: Methods
    
    func configure<C>(with value: C) where C : Hashable {
        guard let item = value as? GifData else { return }
        
        gifImage.image = UIImage(systemName: "photo")
        
        if let s = item.images.fixedWidthSmall?.url ?? item.images.fixedHeightSmall?.url,
           let url = URL(string: s) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self, let data, let img = UIImage(data: data) else { return }
                DispatchQueue.main.async { self.gifImage.image = img }
            }.resume()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Image Constraints
    
    func setupConstraints() {
        
        gifImage.translatesAutoresizingMaskIntoConstraints = false
        gifImage.backgroundColor = .black
        gifImage.contentMode = .scaleAspectFill
        gifImage.clipsToBounds = true
        
        addSubview(gifImage)
        
        
        
        
        
        NSLayoutConstraint.activate([
            gifImage.topAnchor.constraint(equalTo: self.topAnchor),
            gifImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            gifImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gifImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
    }
}
