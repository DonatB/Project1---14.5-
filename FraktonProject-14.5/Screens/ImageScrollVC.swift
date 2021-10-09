//
//  ImageScrollVC.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 16.9.21.
//

import UIKit

class ImageScrollVC: UIViewController {
    
    var userID: Int!
    var userData: User!
    
    var imageView = DBAvatarImageView(frame: .zero)
    lazy var scrollView = DBImageScrollView(frame: self.view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        configure()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserPhoto()
    }
    
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    func getUserPhoto() {
        NetworkManager.shared.getUsersInfo(with: userID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.userData = user
                self.imageView.downloadImage(fromURL: self.userData.avatar)
            case .failure(let error):
                self.presentDBAlertVCOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func configure() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.delegate = self
        scrollView.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        scrollView.gestureRecognizer.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(scrollView.gestureRecognizer)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -100),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
    }
    
    
    @objc func handleDoubleTap() {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scrollView.maximumZoomScale, center: scrollView.gestureRecognizer.location(in: scrollView.gestureRecognizer.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    
    func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}


extension ImageScrollVC: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                
                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height
                
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                
                let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                
                let conditionTop = newHeight*scrollView.zoomScale > imageView.frame.height
                let top = 0.5 * (conditionTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            } else {
                scrollView.contentInset = .zero
            }
        }
    }
}
