//
//  DBEmptyStateView.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 7.9.21.
//

import UIKit

class DBEmptyStateView: UIView {
    
    let messageLabel = DBTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    
    private func configure() {
        addSubviews(messageLabel, logoImageView)
        
        backgroundColor = .systemBackground
        
        messageLabel.numberOfLines = 5
        messageLabel.textColor = .secondaryLabel
        
        logoImageView.image = Images.fraktonLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -50 : -150
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.2),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.2),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 248),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 65)
        ])
    }
}
