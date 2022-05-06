//
//  UserInfoScreen.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/22/20.
//

import UIKit

// MARK: - Delegate

protocol UserInfoScreenDelegate: class {
    func didRequestFollowers(for username: String)
}

class UserInfoScreen: UIViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentView = UIView()

    let headerView = UIView()
    let firstItemView = UIView()
    let secondItemView = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    var itemViews = [UIView]()

    private var username: String
    weak var delegate: UserInfoScreenDelegate!

    // MARK: - Initializers

    init(username: String) {
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureScrollView()
        configureLayout()
        getUserInfo()
    }

    // MARK: - Defined methods

    private func configureScreen() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissScreen))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.pinToEdges(of: view)
        scrollView.addSubview(contentView)
        contentView.pinToEdges(of: scrollView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }

    private func configureLayout() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        itemViews = [headerView, firstItemView, secondItemView, dateLabel]

        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            firstItemView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            firstItemView.heightAnchor.constraint(equalToConstant: itemHeight),
            secondItemView.topAnchor.constraint(equalTo: firstItemView.bottomAnchor, constant: padding),
            secondItemView.heightAnchor.constraint(equalToConstant: itemHeight),
            dateLabel.topAnchor.constraint(equalTo: secondItemView.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUserInterfaceElements(with: user) }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "Okay")
            }
        }
    }

    private func configureUserInterfaceElements(with user: User) {
        self.add(GFUserInfoHeaderViewController(user: user), to: self.headerView)
        self.add(GFRepoItemViewController(user: user, delegate: self), to: self.firstItemView)
        self.add(GFFollowerItemViewController(user: user, delegate: self), to: self.secondItemView)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }

    private func add(_ childViewController: UIViewController, to containerView: UIView) {
        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.frame = containerView.bounds
        childViewController.didMove(toParent: self)
    }

    // MARK: - Action methods

    @objc private func dismissScreen() {
        dismiss(animated: true)
    }
}

// MARK: - Repo item methods

extension UserInfoScreen: GFRepoItemViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "Okay")
            return
        }

        presentSafariViewController(with: url)
    }
}

// MARK: - Follower item methods

extension UserInfoScreen: GFFollowerItemViewControllerDelegate {
    func didTapGetFollowers(for user: User) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "\(user.name ?? "This user") has no followers. What a shame 😞.", buttonTitle: "So sad")
            return
        }

        delegate.didRequestFollowers(for: user.login)
        dismissScreen()
    }
}
