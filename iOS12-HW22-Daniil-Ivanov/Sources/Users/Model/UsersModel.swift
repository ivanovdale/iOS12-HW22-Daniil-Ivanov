//
//  UserModel.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 26.04.2024.
//

import Foundation

protocol UsersModelProtocol {
    var users: [User] { get }
    func setOnUsersChangedHandler(_: DatabaseActionClosure?)
    func addUser(withName name: String)
    func deleteUser(_: User)
}

final class UsersModel {

    // MARK: - Dependecies

    struct Dependencies {
        let usersManager: UsersDatabaseManager
        let randomDataGenerator: RandomDataGeneratorProtocol
    }

    private var usersManager: UsersDatabaseManager
    private let randomDataGenerator: RandomDataGeneratorProtocol

    var onUsersChanged: DatabaseActionClosure? {
        didSet {
            usersManager.onChanged = onUsersChanged
        }
    }

    init(dependencies: Dependencies) {
        self.usersManager = dependencies.usersManager
        self.randomDataGenerator = dependencies.randomDataGenerator
    }
}

// MARK: - UsersModelProtocol

extension UsersModel: UsersModelProtocol {
    var users: [User] {
        usersManager.savedEntities
    }

    func setOnUsersChangedHandler(_ handler: DatabaseActionClosure?) {
        usersManager.onChanged = handler
    }

    func addUser(withName name: String) {
        let surname = randomDataGenerator.randomSurname()
        let birthday = randomDataGenerator.randomBirthday()
        let gender = randomDataGenerator.randomGender()
        usersManager.addUser(name: name,
                             surname: surname,
                             birthday: birthday,
                             gender: gender.rawValue)
    }

    func deleteUser(_ user: User) {
        usersManager.deleteUser(user)
    }
}
