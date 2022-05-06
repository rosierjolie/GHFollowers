//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/21/20.
//

import UIKit

class GFAvatarImageView: UIImageView {
    static let placeholderImage = Images.placeholder
    let cache = NetworkManager.shared.cache

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(fromURL url: String) {
        NetworkManager.shared.downloadAvatarImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }

    private func configureImageView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        clipsToBounds = true
        image = GFAvatarImageView.placeholderImage
    }
}
