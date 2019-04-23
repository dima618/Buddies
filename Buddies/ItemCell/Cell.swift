//
//  Cell.swift
//  Buddies
//
//  Created by Dima Ilin on 4/20/19.
//  Copyright © 2019 Dima Ilin. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "naturo-monkey-selfie")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(red: 20.0, green: 211.0, blue: 193.0, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    func setupViews() {
        //self.backgroundColor = UIColor.blue
        addSubview(profileImageView)
        constraintsFormat(format: "H:|-0-[v0]-0-|", view: profileImageView)
        constraintsFormat(format: "V:|-0-[v0]-0-|", view: profileImageView)
        profileImageView.layer.cornerRadius = 6.0
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.clear.cgColor
        profileImageView.layer.masksToBounds = true
    }
    
    

}

extension UIView {
    func constraintsFormat(format: String, view: UIView) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": view]))
    }
}
