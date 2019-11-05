//
//  CharacterDetailViewController.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    var comics:[Comic] = [Comic]()

    let cellIdentifier = "comicCell"
    
    private lazy var collectionView:UICollectionView = {
        let l = UICollectionViewFlowLayout()
        var itemSize = CGSize(width: 150, height: 200)
        
        l.itemSize = itemSize
        l.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        l.scrollDirection = .horizontal
        let c = UICollectionView(frame: .zero, collectionViewLayout: l)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.dataSource = self
        c.backgroundColor = .white
        return c
    }()
    
    
    private lazy var scrollView:UIScrollView = {
        let s = UIScrollView(frame: .zero)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .white
        return s
    }()
    
    
    private lazy var contentView:UIView = {
        let v = UIView(frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    lazy var characterName:UILabel = {
        let l = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            l.font = UIFont.systemFont(ofSize: 36)
        }
        l.translatesAutoresizingMaskIntoConstraints = false
        
        return l
    }()
    
    lazy var characterImage:MarvelImageView = {
        let m = MarvelImageView()
        m.contentMode = .scaleAspectFill
        m.layer.masksToBounds = true
        return m
    }()
    
    lazy var characterDescription:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            l.font = UIFont.systemFont(ofSize: 26)
        }
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    let character:Character
    
    required init(character:Character) {
        self.character = character
        
        super.init(nibName: nil, bundle: nil)
        setUpView()
        
        API.shared.getComics(characterId: character.id) { (comics, error) in
            
            self.comics = comics
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        view.backgroundColor = .white
        self.title = character.name
        
        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        
        [characterName, characterImage, characterDescription, collectionView].forEach(contentView.addSubview)
               
               NSLayoutConstraint.activate([
                   characterName.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                   characterName.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                   
                   characterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                   characterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                   characterImage.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 8),
                   characterImage.heightAnchor.constraint(equalToConstant: 600),
                   
                   characterDescription.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                   characterDescription.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                   characterDescription.topAnchor.constraint(equalTo: characterImage.bottomAnchor, constant: 16),
                   
                   collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                   collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                   collectionView.topAnchor.constraint(equalTo: characterDescription.bottomAnchor, constant: 8),
                   collectionView.heightAnchor.constraint(equalToConstant: 200),
                   collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
               ])
        
        characterName.text = character.name
        characterImage.downloadImageFrom(urlImage: character.thumbnail.path, imageMode: .scaleAspectFit)
        characterDescription.text = character.description != "" ? character.description:"No description"
        
    }
    
}

extension CharacterDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:ComicCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ComicCollectionViewCell
        
        cell.comic = comics[indexPath.row]
        
        return cell
    }
}

