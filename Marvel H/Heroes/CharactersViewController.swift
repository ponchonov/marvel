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
    var isDataLoading = true
    var refreshControl = UIRefreshControl()

    
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
        c.backgroundColor = UIColor(red:0.89, green:0.90, blue:0.90, alpha:1.00)
        
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getInitialData()
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setUpView()
        self.title = "Heroes"
    }
    override func viewDidAppear(_ animated: Bool) {
        setupLayout()
        navigationController?.navigationBar.barTintColor = UIColor(red:0.86, green:0.38, blue:0.33, alpha:1.00)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isOpaque = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView()  {
        self.view.backgroundColor = .white
        
        self.collectionView.alwaysBounceVertical = true
        self.refreshControl.tintColor = UIColor.red
        self.refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView.addSubview(refreshControl)
        
        
        [collectionView].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY >= (scrollView.contentSize.height - scrollView.bounds.height) - 40 /* Needed offset */ {
            guard !self.isDataLoading else { return }
            self.isDataLoading = true
            
            API.shared.getHeroes(heroesPerPage: UIDevice.current.userInterfaceIdiom == .pad ? 20:10, nextPage: true) { (characters, error) in
                self.characters.append(contentsOf: characters)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isDataLoading = false
                }
            }
        }
    }
    
    func getInitialData()  {
        API.shared.getHeroes(heroesPerPage: UIDevice.current.userInterfaceIdiom == .pad ? 20:10) { (heroes, error) in
            self.characters = heroes
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.isDataLoading = false
                self.stopRefresher()
            }
        }
    }
    
    func setupLayout()  {
        
        var itemSize:CGSize?
        var numberOfColumns:CGFloat = 1
        if UIDevice.current.userInterfaceIdiom == .pad {
            numberOfColumns = 3
            if (UIDevice.current.orientation.isLandscape && UIDevice.current.userInterfaceIdiom == .pad ){
                numberOfColumns = 5
            }
        }
        itemSize = CGSize(width: UIScreen.main.bounds.width/numberOfColumns - 10 , height: 500)
        
        let l = UICollectionViewFlowLayout()
        
        l.itemSize = itemSize!
        l.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.collectionViewLayout = l
        self.collectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setupLayout()
    }
    
    @objc func loadData() {
       refreshControl.beginRefreshing()
        getInitialData()
     }

    func stopRefresher() {
       refreshControl.endRefreshing()
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
