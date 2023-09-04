//
//  FriendsTableViewController.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit

final class FriendTableViewController: UITableViewController {
    private var friendsModel: FriendsModel?
    private var fileCache = FileCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = Constants.Titles.friendsTitle
        tableView.register(FriendCell.self, forCellReuseIdentifier: Constants.CellNames.friendsCellName)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(showPersonalInfo))

        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(updateFriends), for: .valueChanged)

        NetworkService().getFriends { [weak self] result in
            switch result {
            case .failure: do {
                    self?.friendsModel = self?.fileCache.getFriends()

                    if self?.friendsModel?.response?.count == 0 {
                        // а нету друзей! меняем заголовое на "Нет друзей"
                        DispatchQueue.main.async {
                            self?.title = Constants.TitlesNoItems.friendsTitle
                        }
                    }
                    DispatchQueue.main.async {
                        self?.showAlert()
                    }
                }
            case let .success(friendsModel):
                do {
                    self?.friendsModel = friendsModel

                    self?.fileCache.putFriends(friends: self?.friendsModel?.response?.items ?? [])

                    if friendsModel.response?.count == 0 {
                        // а нету друзей! меняем заголовое на "Нет друзей"
                        DispatchQueue.main.async {
                            self?.title = Constants.TitlesNoItems.friendsTitle
                        }
                    } else {
                        self?.friendsModel = friendsModel

                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = Theme.currentTheme.backgroundColor
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Не удалось получить данные о друзьях",
                                      message: "Данные прочитаны локально за дату \(DateHelper.getDateString(date: fileCache.getFriendDate()))",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc private func showPersonalInfo() {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 1
        navigationController?.view.layer.add(animation, forKey: nil)
        navigationController?.pushViewController(ProfileViewController(isUserProfile: true), animated: false)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return friendsModel?.response?.count ?? 0
    }

    @objc private func updateFriends() {
        NetworkService().getFriends { [weak self] result in
            switch result {
            case .failure: do {
                    self?.friendsModel = self?.fileCache.getFriends()

                    if self?.friendsModel?.response?.count == 0 {
                        // а нету друзей! меняем заголовое на "Нет друзей"
                        DispatchQueue.main.async {
                            self?.title = Constants.TitlesNoItems.friendsTitle
                        }
                    }
                    DispatchQueue.main.async {
                        self?.showAlert()
                    }
                }
            case let .success(friendsModel):
                do {
                    self?.friendsModel = friendsModel

                    self?.fileCache.putFriends(friends: self?.friendsModel?.response?.items ?? [])

                    if friendsModel.response?.count == 0 {
                        // а нету друзей! меняем заголовое на "Нет друзей"
                        DispatchQueue.main.async {
                            self?.title = Constants.TitlesNoItems.friendsTitle
                        }
                    } else {
                        self?.friendsModel = friendsModel

                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
            }
        }
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let friendCell =
            tableView.dequeueReusableCell(withIdentifier: Constants.CellNames.friendsCellName, for: indexPath) as? FriendCell
        else {
            return UITableViewCell()
        }
        guard let friend = friendsModel?.response?.items?[indexPath.row] else {
            return UITableViewCell()
        }
        friendCell.update(friend: friend)
        friendCell.tap = { [weak self] name, photo in
            self?.navigationController?.pushViewController(ProfileViewController(name: name, photo: photo, isUserProfile: false), animated: true)
        }
        return friendCell
    }
}
