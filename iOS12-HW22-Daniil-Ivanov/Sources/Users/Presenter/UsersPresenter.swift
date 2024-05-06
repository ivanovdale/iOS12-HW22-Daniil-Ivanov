//
//  UsersPresenter.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 26.04.2024.
//

import Foundation

protocol UsersPresenterProtocol {
    var users: [User] { get }
    
    func loadView(controller: UsersViewController, view: UsersViewProtocol)

    func deleteUser(_: User)

    func goToUserDetails(_ user: User)
}

final class UsersPresenter {
    struct Dependencies {
        let model: UsersModelProtocol
        let router: Router
    }
    
    private weak var controller: UsersViewController?
    private weak var view: UsersViewProtocol?

    // MARK: - Dependecies

    private var model: UsersModelProtocol
    private let router: Router

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.model = dependencies.model
        self.router = dependencies.router
    }
}

// MARK: - UsersPresenterProtocol

extension UsersPresenter: UsersPresenterProtocol {
    var users: [User] {
        model.users
    }

    func loadView(controller: UsersViewController, view: UsersViewProtocol) {
        self.controller = controller
        self.view = view

        setHandlers()
        setTableViewDataSource()
        setTableViewDelegate()
    }

    func deleteUser(_ user: User) {
        model.deleteUser(user)
    }

    func goToUserDetails(_ user: User) {
        router.goToUserDetails(user)
    }
}

// MARK: - Private methods

private extension UsersPresenter {

    // MARK: Presentation logic

    func addUser() {
        guard let view else { return }
        let userName = view.getTextFieldData()
        model.addUser(withName: userName)
        view.clearTextField()
    }

    // MARK: Handlers

    func setHandlers() {
        guard let view else { return }
        view.onAddUserHandler = { [weak self] in
            guard let self else { return }
            addUser()
        }

        model.setOnUsersChangedHandler { action in
            switch (action) {
            case .add, .update:
                view.updateUsersTable()
            case .delete, .none:
                break;
            }
        }
    }

    // MARK: TableView DataSource and Delegate

    func setTableViewDataSource() {
        guard let view else { return }
        view.usersTableViewDataSource = controller
    }

    func setTableViewDelegate() {
        guard let view else { return }
        view.usersTableViewDelegate = controller
    }
}
