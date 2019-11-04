//
//  ViewController.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import UIKit

class CharactersViewController: UIViewController {

    let cellIdentifier = "characterCell"
    var characters:[Character] = [Character]()
    
    lazy var collectionView:UICollectionView = {
        let l = UICollectionViewFlowLayout()
        var itemSize = CGSize(width: UIScreen.main.bounds.width - 26, height: 500)
        
        l.itemSize = itemSize
        l.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        let c = UICollectionView(frame: .zero, collectionViewLayout: l)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        c.dataSource = self
        c.delegate = self
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    init() {
        super.init(nibName: nil, bundle: nil)
        setUpView()
        self.title = "Heroes"
    }
    override func viewDidAppear(_ animated: Bool) {
    
        API.shared.getHeroes(heroesPerPage: 10) { (heroes, error) in
            self.characters = heroes
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView()  {
        self.view.backgroundColor = .white
        
        [collectionView].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}


extension CharactersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:CharacterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CharacterCollectionViewCell
        
        cell.character = characters[indexPath.row]
        
        return cell
    }
}

extension CharactersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let character = characters[indexPath.row]
        let vc = CharacterDetailViewController(character: character)
        
        self.show(vc, sender: nil)
    }
    
}
