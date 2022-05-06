//
//  UIView+Ext.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/28/20.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) { views.forEach(addSubview) }

    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
}
