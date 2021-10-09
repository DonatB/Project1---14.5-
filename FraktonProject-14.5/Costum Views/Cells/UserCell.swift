//
//  UserCell.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 6.9.21.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    static let reuseID = "UserCell"
    
    let avatarImageView = DBAvatarImageView(frame: .zero)
    let usernameLabel = DBTitleLabel(textAlignment: .center, fontSize: 16)
    
    let padding: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(user: User){
        usernameLabel.text = "\(user.fullName!)"
        avatarImageView.downloadImage(fromURL: user.avatar)
    }
    
    
    private func configure() {
        addSubviews(avatarImageView, usernameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }
}
