//
//  MarvelImageView.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import UIKit
import ImageIO


class MarvelImageView: UIView {
    
    let imageCache = NSCache<NSString, AnyObject>()

    var image:UIImage? {
        didSet {
            self.marvelImageView.image = self.image
        }
    }
    
    override var contentMode: UIView.ContentMode {
        didSet {
            self.marvelImageView.contentMode = self.contentMode
        }
    }
    private lazy var marvelImageView:UIImageView = {
        let i = UIImageView(frame: .zero)
        i.translatesAutoresizingMaskIntoConstraints = false
        
        return i
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let i = UIActivityIndicatorView(style: .large)
        i.translatesAutoresizingMaskIntoConstraints = false
        i.color = .black
        i.hidesWhenStopped = true
        i.isHidden = false
        
        return i
    }()
    
    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        [marvelImageView, activityIndicator].forEach(self.addSubview)
        
        NSLayoutConstraint.activate([
            marvelImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            marvelImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            marvelImageView.topAnchor.constraint(equalTo: topAnchor),
            marvelImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    // MARK: - Properties
    
    var imageURLString: String?
    
    func downloadImageFrom(urlImage: URL, imageMode: UIView.ContentMode) {
        
        let url = urlImage.appendingPathComponent("portrait_xlarge.jpg")
        
        self.activityIndicator.startAnimating()
        self.image = nil
        contentMode = imageMode
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
            self.activityIndicator.stopAnimating()
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    self.activityIndicator.stopAnimating()
                    return }
                DispatchQueue.main.async {
                    if let imageToCache = UIImage(data: data) {
                        
                        self.imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                        self.image = imageToCache
                        self.activityIndicator.stopAnimating()
                    }
                }
            }.resume()
        }
    }
}

