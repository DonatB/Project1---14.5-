//
//  UserInfoVC.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 8.9.21.
//

import UIKit
import MessageUI

protocol UserInfoVCDelegate {
    func didTapDoneButton(_ viewController: UserInfoVC)
}

class UserInfoVC: UIViewController {
    
    var userID: Int!
    var userInfo: User!
    let padding: CGFloat = 10
    let favoritesVC = FavoritesListVC()
    
    var prevButtonColor: UIColor {
        if userID <= 1 {
            return .systemGray
        } else {
            return .systemYellow
        }
    }
    
    var nextButtonColor: UIColor {
        if userID >= 12 {
            return .systemGray
        } else {
            return .systemYellow
        }
    }
    
    var updateDelegate: UserInfoVCDelegate!
    
    let imageScrollVC = ImageScrollVC()
    lazy var prevButton = DBButton(backgroundColor: prevButtonColor, title: "Prev User")
    lazy var nextButton = DBButton(backgroundColor: nextButtonColor, title: "Next User")
    let avatarImageView = DBAvatarImageView(frame: .zero)
    let nameLabel = DBTitleLabel(textAlignment: .center, fontSize: 30)
    let emailImageView = UIImageView()
    let emailLabel = DBSecondaryTitleLabel(fontSize: 20)
    let idLabel = DBSecondaryTitleLabel(fontSize: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUINavBar()
        getUsersInfo()
        configurePrevNextButton()
        configureAvatarImageView()
        configureNameLabel()
        configureEmailLabel()
        configureIDLabel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func configureUINavBar() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        let addButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = addButton
    }
    
    
    func getUsersInfo() {
        NetworkManager.shared.getUsersInfo(with: userID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.userInfo = user
                self.configureUIData()
            case .failure(let error):
                self.presentDBAlertVCOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    @objc func dismissVC() {
        updateDelegate?.didTapDoneButton(self)
        dismiss(animated: true)
    }
    
    
    @objc func addButtonTapped() {
        showLoadingView()
        
        NetworkManager.shared.getUsersInfo(with: userID) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case.success(let user):
                self.addUserToFavorites(user: user)
            case.failure(let error):
                self.presentDBAlertVCOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
    
    
    func addUserToFavorites(user: User) {
        let favorite = User(id: user.id, email: user.email, firstName: user.firstName, lastName: user.lastName, avatar: user.avatar)
        
        PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            
            guard let error = error else {
                self.presentDBAlertVCOnMainThread(title: "Success!", message: "\(user.fullName ?? "This user") has been succesfully added! 🥳", buttonTitle: "Ok")
                return
            }
            self.presentDBAlertVCOnMainThread(title: "Unable to favorite", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    func configurePrevNextButton() {
        view.addSubviews(prevButton, nextButton)
        prevButton.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            prevButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            prevButton.widthAnchor.constraint(equalToConstant: 120),
            
            nextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nextButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    
    func configureAvatarImageView(){
        view.addSubview(avatarImageView)
        
        avatarImageView.isUserInteractionEnabled = true
        let gestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(showImageScrollView))
        avatarImageView.addGestureRecognizer(gestureRecogniser)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: prevButton.bottomAnchor, constant: 30),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    
    
    func configureNameLabel() {
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    
    func configureEmailLabel() {
        view.addSubviews(emailImageView, emailLabel)
        
        emailImageView.translatesAutoresizingMaskIntoConstraints = false
        emailImageView.tintColor = .secondaryLabel
        
        emailLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMailComposer))
        emailLabel.addGestureRecognizer(gestureRecognizer)
        
        NSLayoutConstraint.activate([
            emailImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            emailImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            
            emailLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            emailLabel.leadingAnchor.constraint(equalTo: emailImageView.trailingAnchor, constant: padding),
        ])
    }
    
    
    func configureIDLabel() {
        view.addSubview(idLabel)
        
        NSLayoutConstraint.activate([
            idLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            idLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
    
    func configureUIData(){
        DispatchQueue.main.async {
            self.nameLabel.text = self.userInfo.fullName ?? "No Username"
            self.avatarImageView.downloadImage(fromURL: self.userInfo.avatar)
            self.emailLabel.text = self.userInfo.email
            self.idLabel.text = "\(self.userInfo.id)"
            self.emailImageView.image = UIImage(systemName: "envelope.fill")
        }
    }
    
    
    @objc func prevButtonTapped() {
        guard userID <= 12 && userID > 1 else {
            return
        }
        
        userID -= 1
        getUsersInfo()
        
        if userID > 1{
            prevButton.backgroundColor = .systemYellow
        } else {
            prevButton.backgroundColor = .systemGray
        }
        
        if userID < 12 {
            nextButton.backgroundColor = .systemYellow
        } else {
            nextButton.backgroundColor = .systemGray
        }
    }
    
    
    @objc func nextButtonTapped() {
        guard userID < 12 && userID >= 1 else {
            return
        }
        
        userID += 1
        getUsersInfo()
        
        if userID < 12  {
            nextButton.backgroundColor = .systemYellow
        } else {
            nextButton.backgroundColor = .systemGray
        }
        
        if userID > 1{
            prevButton.backgroundColor = .systemYellow
        } else {
            prevButton.backgroundColor = .systemGray
        }
    }
    
    
    @objc func showMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            self.presentDBAlertVCOnMainThread(title: "Error", message: "This device is not able to send mail 😕", buttonTitle: "Ok")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["\(self.userInfo.email)"])
        present(composer, animated: true)
    }
    
    
    @objc func showImageScrollView(){
        let navController = UINavigationController(rootViewController: imageScrollVC)
        imageScrollVC.userID = userID
        present(navController, animated: true)
    }
}


extension UserInfoVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


