//
//  MarvelSearchTVCell.swift
//  RxSwiftMVVM
//
//  Created by cashwalk on 21/12/2018.
//  Copyright © 2018 cashwalk. All rights reserved.
//

import UIKit

import Then
import Kingfisher

class MarvelSearchTVCell: UITableViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "MarvelSearchTVCell"
    
    // MARK: - Properties
    
    var hero: MarvelHeroModel? {
        didSet {
            guard let hero = hero else {return}
            
            if let thumnail = hero.thumbnail, let url = URL(string: thumnail) {
                print("//zz herourl : \(url)")
                heroImageView.kf.setImage(with: url)
            }
            if let name = hero.name {
                heroTitleLabel.text = name
            }
        }
    }
    
    // MARK: - UI Components
    
    private let heroImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
    }
    private let heroTitleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        $0.font = .systemFont(ofSize: 20, weight: .black)
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setProperties()
        contentView.addSubview(heroImageView)
        contentView.addSubview(heroTitleLabel)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heroImageView.image = nil
        heroTitleLabel.text = nil
    }
    
    private func setProperties() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}

// MARK: - Layout

extension MarvelSearchTVCell {
    
    private func layout() {
        heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        heroImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        heroTitleLabel.topAnchor.constraint(equalTo: heroImageView.topAnchor).isActive = true
        heroTitleLabel.leadingAnchor.constraint(equalTo: heroImageView.leadingAnchor).isActive = true
        heroTitleLabel.trailingAnchor.constraint(equalTo: heroImageView.trailingAnchor).isActive = true
        heroTitleLabel.bottomAnchor.constraint(equalTo: heroImageView.bottomAnchor).isActive = true
    }
}
