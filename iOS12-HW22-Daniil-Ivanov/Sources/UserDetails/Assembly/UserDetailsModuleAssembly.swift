//
//  UserDetailsModuleAssembly.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 03.05.2024.
//

import Foundation

import UIKit

final class UserDetailsModuleAssembly {
    struct Dependencies {
        let user: User
    }

    static func build(with dependencies: Dependencies) -> UIViewController {
        let model = UserDetailsModel(dependencies: .init(usersManager: usersManager,
                                                         user: dependencies.user))

        let presenter = UserDetailsPresenter(dependencies: .init(model: model, router: router))

        let controller = UserDetailsViewController(dependencies: .init(presenter: presenter))

        return controller
    }
}
