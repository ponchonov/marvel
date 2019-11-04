//
//  CharacterDetailViewController.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import UIKit

class CharacterDetailViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    let character:Character
    
    required init(character:Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        view.backgroundColor = .white
        self.title = character.name
        
        [characterName, characterImage].forEach(view.addSubview)
               
               NSLayoutConstraint.activate([
                   characterName.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
                   characterName.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
                   
                   characterImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   characterImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   characterImage.topAnchor.constraint(equalTo: characterName.bottomAnchor, constant: 8),
                   characterImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
               ])
        
        characterName.text = character.name
        characterImage.setImageWith(imageUrl: character.thumbnail.path)
        
    }
    
}
