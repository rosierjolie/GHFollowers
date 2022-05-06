//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by Jerry Turcios on 10/28/20.
//

import UIKit

extension UITableView {
    func reloadDataOnMainThread() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
