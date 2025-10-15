//
//  SelfConfigureCell.swift
//  GifFinder
//
//  Created by David Puksanskis on 14/10/2025.
//

protocol SelfConfigureCell {
    static var reuseId: String { get }
    
    func configure<C: Hashable>(with value: C)
}
