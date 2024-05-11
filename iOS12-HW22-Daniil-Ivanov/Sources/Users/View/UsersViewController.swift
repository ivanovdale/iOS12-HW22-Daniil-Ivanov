//
//  ViewController.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 26.04.2024.
//

import UIKit

final class UsersViewController: UIViewController {

    // MARK: - Dependencies

    struct Dependencies {
        let presenter: UsersPresenterProtocol
    }

    private var usersPresenter: UsersPresenterProtocol!

    // MARK: - Data

    var users: [User] {
        usersPresenter.users
    }

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.usersPresenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        let usersView = UsersView()
        self.usersPresenter.loadView(controller: self, view: usersView)
        view = usersView
    }
}

// MARK: - UITableViewDataSource

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = users[indexPath.row].description
        cell.contentConfiguration = config
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[indexPath.row]
            usersPresenter.deleteUser(user)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        usersPresenter.goToUserDetails(user)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
