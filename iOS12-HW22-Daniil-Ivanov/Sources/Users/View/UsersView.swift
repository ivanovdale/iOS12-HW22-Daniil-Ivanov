//
//  UsersView.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 26.04.2024.
//

import UIKit
import SnapKit

protocol UsersViewProtocol: AnyObject {

    // MARK: - Handlers

    var onAddUserHandler: (() -> Void)? { get set }

    // MARK: - TableView Delegate and DataSource

    var usersTableViewDataSource: UITableViewDataSource? { get set }

    var usersTableViewDelegate: UITableViewDelegate? { get set }

    // MARK: - UI update

    func getTextFieldData() -> String

    func updateUsersTable()

    func clearTextField()
}

final class UsersView: UIView {

    // MARK: - Handlers

    var onAddUserHandler: (() -> Void)?

    // MARK: - TableView Delegate and DataSource

    var usersTableViewDataSource: UITableViewDataSource? {
        didSet {
            usersTable.dataSource = self.usersTableViewDataSource
        }
    }

    var usersTableViewDelegate: UITableViewDelegate? {
        didSet {
            usersTable.delegate = self.usersTableViewDelegate
        }
    }

    // MARK: - Outlets

    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Users"
        label.textColor = .label
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.placeholder = "Enter your name here"
        textField.setLeftPaddingPoints(10)
        return textField
    }()

    private lazy var addUserButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(onAddUserButtonTapped), for: .touchUpInside)
        button.setTitle("Add", for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()

    private lazy var usersTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .systemGray6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupHierarchy() {
        [
            title,
            userNameTextField,
            addUserButton,
            usersTable,
        ].forEach { addSubview($0) }
    }

    private func setupLayout() {
        title.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
        }

        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(title.snp_bottomMargin).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }

        addUserButton.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp_bottomMargin).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }

        usersTable.snp.makeConstraints { make in
            make.top.equalTo(addUserButton.snp_bottomMargin).offset(36)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupView() {
        backgroundColor = .systemBackground
    }
}

// MARK: - UsersViewProtocol

extension UsersView: UsersViewProtocol {
    func getTextFieldData() -> String {
        userNameTextField.text ?? ""
    }

    func updateUsersTable() {
        usersTable.reloadData()
    }

    func clearTextField() {
        userNameTextField.text = ""
    }
}

// MARK: - Private methods

private extension UsersView {

    // MARK: Actions

    @objc func onAddUserButtonTapped() {
        self.onAddUserHandler?()
    }
}
