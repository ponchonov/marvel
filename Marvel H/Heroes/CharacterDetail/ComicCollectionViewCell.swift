//
//  ComicCollectionViewCell.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {
    lazy var comicName:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.lineBreakMode = .byTruncatingMiddle
        return l
    }()
    
    lazy var comicImage:MarvelImageView = {
        let m = MarvelImageView()
        m.contentMode = .scaleAspectFill
        m.layer.masksToBounds = true
        return m
    }()
    
    var comic:Comic? {
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
        comicName.text = nil
        guard let comic = self.comic else {return}
        
        comicName.text = comic.title
        
        comicImage.setImageWith(imageUrl: comic.thumbnail.path)
    }
    
    func setUpView()  {
        self.backgroundColor = .white
        [comicName, comicImage].forEach(contentView.addSubview)
        
        NSLayoutConstraint.activate([
            comicName.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            comicName.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            comicName.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            comicImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            comicImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            comicImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            comicImage.topAnchor.constraint(equalTo: comicName.bottomAnchor, constant: 8),
        ])
    }
}
