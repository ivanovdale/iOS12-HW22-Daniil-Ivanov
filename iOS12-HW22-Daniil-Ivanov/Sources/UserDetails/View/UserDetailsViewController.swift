//
//  UserDetailsViewController.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 03.05.2024.
//

import UIKit

final class UserDetailsViewController: UIViewController {

    // MARK: - Dependencies

    struct Dependencies {
        let presenter: UserDetailsPresenterProtocol
    }

    private var userDetailsPresenter: UserDetailsPresenterProtocol!

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.userDetailsPresenter = dependencies.presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        let userDetailsView = UserDetailsView()
        self.userDetailsPresenter.loadView(controller: self, view: userDetailsView)
        view = userDetailsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
    }

    // MARK: - Setup

    private func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
}
