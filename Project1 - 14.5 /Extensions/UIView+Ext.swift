//
//  UIView+Ext.swift
//  Project1 - 14.5 
//
//  Created by Donat Bajrami on 28.9.21.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
