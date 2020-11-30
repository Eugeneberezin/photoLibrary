//
//  PhotoCell.swift
//  PhotoLibrary
//
//  Created by Eugene Berezin on 11/28/20.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let cellID = "PhotoCellID"
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    func configureUI() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        imageView.backgroundColor = .yellow
        imageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
