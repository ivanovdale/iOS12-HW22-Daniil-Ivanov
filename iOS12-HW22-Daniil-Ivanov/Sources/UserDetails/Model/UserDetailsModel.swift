//
//  UserDetailsModel.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 03.05.2024.
//

import Foundation

typealias DateRange = (min: Date, max: Date)

protocol UserDetailsModelProtocol {
    var user: User { get }
    func updateUser(name: String,
                    surname: String,
                    birthday: Date,
                    gender: String)

    func getBirthdayRange() -> DateRange
}

final class UserDetailsModel {
    struct Dependencies {
        let usersManager: UsersDatabaseManager
        let user: User
    }

    // MARK: - Dependencies

    private let usersManager: UsersDatabaseManager
    var user: User

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.usersManager = dependencies.usersManager
        self.user = dependencies.user
    }
}

// MARK: - UserDetailsModelProtocol

extension UserDetailsModel: UserDetailsModelProtocol {
    func updateUser(name: String,
                    surname: String,
                    birthday: Date,
                    gender: String) {
        usersManager.updateUser(user: user,
                                name: name,
                                surname: surname,
                                birthday: birthday,
                                gender: gender)
    }

    func getBirthdayRange() -> DateRange {
        return (min: RandomDataGenerator.birthdayLowerBound, max: RandomDataGenerator.birthdayUpperBound)
    }
}
