//
//  DBImageScrollView.swift
//  FraktonTestProject
//
//  Created by Donat Bajrami on 16.9.21.
//

import UIKit

class DBImageScrollView: UIScrollView {
    
    var gestureRecognizer: UITapGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        backgroundColor = .systemBackground
        minimumZoomScale = 1
        maximumZoomScale = 4
        zoomScale = 1
        isPagingEnabled = true
        bouncesZoom = true
    }
}
