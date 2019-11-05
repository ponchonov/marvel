//
//  ComicDetailViewController.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import UIKit

class ComicDetailViewController: UIViewController {

    
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
        
        lazy var comicTitle:UILabel = {
            let l = UILabel()
            if UIDevice.current.userInterfaceIdiom == .pad {
                l.font = UIFont.systemFont(ofSize: 36)
            }
            l.translatesAutoresizingMaskIntoConstraints = false
            
            return l
        }()
        
        lazy var comicImage:MarvelImageView = {
            let m = MarvelImageView()
            m.contentMode = .scaleAspectFill
            m.layer.masksToBounds = true
            return m
        }()
        
        lazy var comicDescription:UILabel = {
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
        
        let comic:Comic
        
        required init(comic:Comic) {
            self.comic = comic
            super.init(nibName: nil, bundle: nil)
            setUpView()
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setUpView() {
            view.backgroundColor = .white
            self.title = comic.title
            
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
            
            
            [comicTitle, comicImage, comicDescription].forEach(contentView.addSubview)
                   
                   NSLayoutConstraint.activate([
                       comicTitle.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                       comicTitle.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
                       
                       comicImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                       comicImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                       comicImage.topAnchor.constraint(equalTo: comicTitle.bottomAnchor, constant: 8),
                       comicImage.heightAnchor.constraint(equalToConstant: 600),
                       
                       comicDescription.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
                       comicDescription.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
                       comicDescription.topAnchor.constraint(equalTo: comicImage.bottomAnchor, constant: 16),
                       comicDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                   ])
            
            comicTitle.text = comic.title
            comicImage.downloadImageFrom(urlImage: comic.thumbnail.path, imageMode: .scaleAspectFit)
            comicDescription.text = comic.description != "" ? comic.description:"No description"
        }
        
    }


