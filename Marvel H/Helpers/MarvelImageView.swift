//
//  MarvelImageView.swift
//  Marvel H
//
//  Created by Héctor Cuevas on 04/11/19.
//  Copyright © 2019 Héctor Cuevas. All rights reserved.
//

import UIKit
import ImageIO

let imageCache = NSCache<AnyObject, AnyObject>()

class MarvelImageView: UIView {
    
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
    
    func setImageWith(imageUrl:URL) {
        self.activityIndicator.stopAnimating()

        let key = imageUrl.lastPathComponent
        let url = imageUrl.appendingPathComponent("portrait_xlarge.jpg")
        if let cachedImage = imageCache.object(forKey: key as NSString) as? UIImage {
            self.image = cachedImage
        } else {
            
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                
                DispatchQueue.global(qos: .background).async {
                    do {
                        let data = try Data(contentsOf: url)
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data) {
                                imageCache.setObject(image, forKey: key as NSString)
                                self.image = image
                            }
                            self.activityIndicator.stopAnimating()
                        }
                    } catch (let e) {
                        print(e)
                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }
}
