//
//  FavoriteCell.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 21.9.21.
//

import UIKit

class FavoriteCell: UITableViewCell {

    static let reuseID = "FavoriteCell"
    
    let avatarImageView = DBAvatarImageView(frame: .zero)
    let usernameLabel = DBTitleLabel(textAlignment: .left, fontSize: 26)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func set(favorite: User){
        usernameLabel.text = "\(favorite.fullName!)"
        avatarImageView.downloadImage(fromURL: favorite.avatar)
    }
    
    
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        
        accessoryType = .disclosureIndicator
        
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
