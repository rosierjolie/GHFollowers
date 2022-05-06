//
//  FollowerCell.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/21/20.
//

import UIKit

class FollowerCell: UICollectionViewCell {
    // MARK: - Properties

    static let reuseId = "FollowerCell"
    let avatarImageView = GFAvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)

    let padding: CGFloat = 8

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(avatarImageView, usernameLabel)
        configureAvatarImageView()
        configureUsernameLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Defined methods

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = GFAvatarImageView.placeholderImage
    }

    func set(follower: Follower) {
        usernameLabel.text = follower.login
        avatarImageView.setImage(fromURL: follower.avatarUrl)
    }

    private func configureAvatarImageView() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
        ])
    }

    private func configureUsernameLabel() {
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
