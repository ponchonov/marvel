//
//  CharacterCollectionViewCell.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    lazy var characterName:UILabel = {
       let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var characterImage:MarvelImageView = {
        let m = MarvelImageView()
        m.contentMode = .scaleAspectFill
        m.layer.masksToBounds = true
        return m
    }()
    
    var character:Character? {
        didSet {
            setUpData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpData() {
        guard let character = self.character else {return}
        characterName.text = character.name
        characterImage.downloadImageFrom(urlImage: character.thumbnail.path, imageMode: .scaleToFill)
    }
    
    func setUpView()  {
        self.backgroundColor = .white
        [characterName, characterImage].forEach(contentView.addSubview)
        
        NSLayoutConstraint.activate([
            characterName.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            characterName.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            
            characterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            characterImage.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 8),
        ])
    }
}
