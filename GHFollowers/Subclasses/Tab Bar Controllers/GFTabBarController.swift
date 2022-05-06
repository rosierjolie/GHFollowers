//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/26/20.
//

import UIKit

class GFTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [ createSearchNavigation(), createFavoritesNavigation() ]
    }

    private func createSearchNavigation() -> UINavigationController {
        let searchScreen = SearchScreen()
        searchScreen.title = "Search"
        searchScreen.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

        return UINavigationController(rootViewController: searchScreen)
    }

    private func createFavoritesNavigation() -> UINavigationController {
        let favoritesListScreen = FavoritesListScreen()
        favoritesListScreen.title = "Favorites"
        favoritesListScreen.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)

        return UINavigationController(rootViewController: favoritesListScreen)
    }
}
