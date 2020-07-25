//
//  InsideGroupCollectionViewCell.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-26.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import UIKit

class InsideGroupCollectionViewCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            guard let data = data else { return }
            menuImageView.image = data.menuImage
            menuDescriptionTextView.attributedText = data.menuDescription
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let menuImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    let menuDescriptionTextView: UITextView = {
       let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    func setupLayout(){
        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        addSubview(menuDescriptionTextView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topImageContainerView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        topImageContainerView.addSubview(menuImageView)
        menuImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        menuImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100).isActive = true
        menuImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        menuDescriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        menuDescriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        menuDescriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
    }
}
