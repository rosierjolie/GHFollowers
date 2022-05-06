//
//  GFItemInfoViewController.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/23/20.
//

import UIKit

class GFItemInfoViewController: UIViewController {
    // MARK: - Properties

    let stackView = UIStackView()
    let firstItemInfoView = GFItemInfoView()
    let secondItemInfoView = GFItemInfoView()
    let actionButton = GFButton()

    var user: User

    let padding: CGFloat = 20

    // MARK: - Initializers

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(stackView, actionButton)
        configureViewController()
        configureStackView()
        configureActionButton()
    }

    // MARK: - Defined methods

    private func configureViewController() {
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 18
    }

    private func configureStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(firstItemInfoView)
        stackView.addArrangedSubview(secondItemInfoView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc func actionButtonTapped() {}
}
