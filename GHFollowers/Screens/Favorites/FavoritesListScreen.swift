//
//  FavoritesListScreen.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/19/20.
//

import UIKit

class FavoritesListScreen: GFDataLoadingViewController {
    // MARK: - Properties

    let favoritesTableView = UITableView()
    var favorites = [Follower]()

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureFavoritesTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    // MARK: - Defined methods

    private func configureScreen() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func configureFavoritesTableView() {
        view.addSubview(favoritesTableView)
        favoritesTableView.frame = view.bounds
        favoritesTableView.rowHeight = 80
        favoritesTableView.dataSource = self
        favoritesTableView.delegate = self
        favoritesTableView.tableFooterView = UIView()
        favoritesTableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseId)
    }

    private func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }

            self.view.subviews.forEach { subView in
                if subView is GFEmptyStateView {
                    subView.removeFromSuperview()
                }
            }

            switch result {
            case .success(let favorites):
                self.updateUI(with: favorites)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Okay")
            }
        }
    }

    private func updateUI(with favorites: [Follower]) {
        if favorites.isEmpty {
            self.favoritesTableView.isHidden = true
            self.showEmptyStateView(with: "No favorites?\nAdd one on the follower list screen 😀.", in: self.view)
        } else {
            self.favorites = favorites
            DispatchQueue.main.async {
                self.favoritesTableView.isHidden = false
                self.favoritesTableView.reloadData()
            }
        }
    }
}

// MARK: - Table view methods

extension FavoritesListScreen: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseId) as! FavoriteCell
        let favorite = favorites[indexPath.row]
        cell.set(favorite: favorite)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationScreen = FollowerListScreen(username: favorite.login)
        navigationController?.pushViewController(destinationScreen, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }

            guard let error = error else {
                self.favorites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)

                if self.favorites.isEmpty {
                    self.favoritesTableView.isHidden = true
                    self.showEmptyStateView(with: "No favorites?\nAdd one on the follower list screen 😀.", in: self.view)
                }

                return
            }

            self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Okay")
        }
    }
}
