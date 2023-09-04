//
//  GroupsTableViewController.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit

final class GroupsTableViewController: UITableViewController {
    private var groupsModel: GroupsModel?
    private var fileCache = FileCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Titles.groupsTitle
        tableView.register(GroupCell.self, forCellReuseIdentifier: Constants.CellNames.groupsCellName)

        NetworkService().getGroups { [weak self] result in
            switch result {
            case .failure: do {
                    self?.groupsModel = self?.fileCache.getGroups()

                    if self?.groupsModel?.response?.count == 0 {
                        // а нету групп! меняем заголовое на "Нет групп"
                        DispatchQueue.main.async {
                            self?.title = Constants.TitlesNoItems.groupsTitle
                        }
                    }
                    DispatchQueue.main.async {
                        self?.showAlert()
                    }
                }
            case let .success(groupsModel): do {
                    self?.groupsModel = groupsModel

                    self?.fileCache.putGroups(groups: self?.groupsModel?.response?.items ?? [])

                    if groupsModel.response?.count == 0 {
                        // а нету групп! меняем заголовое на "Нет групп"
                        DispatchQueue.main.async {
                            self?.title = Constants.TitlesNoItems.groupsTitle
                        }
                    } else {
                        self?.groupsModel = groupsModel

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

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return groupsModel?.response?.count ?? 0
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let groupCell =
            tableView.dequeueReusableCell(withIdentifier: Constants.CellNames.groupsCellName, for: indexPath) as? GroupCell
        else {
            return UITableViewCell()
        }
        guard let group = groupsModel?.response?.items?[indexPath.row] else {
            return UITableViewCell()
        }
        groupCell.update(group: group)
        return groupCell
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Не удалось получить данные о группах",
                                      message: "Данные прочитаны локально за дату \(DateHelper.getDateString(date: fileCache.getFriendDate()))",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
