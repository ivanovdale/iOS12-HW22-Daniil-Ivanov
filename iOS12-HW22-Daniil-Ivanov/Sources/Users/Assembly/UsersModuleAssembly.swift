//
//  UsersModuleAssembly.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 30.04.2024.
//

import UIKit

final class UsersModuleAssembly {
    static func build() -> UIViewController {
        let dataGenerator = RandomDataGenerator()
        let model = UsersModel(dependencies: .init(usersManager: usersManager,
                                                   randomDataGenerator: dataGenerator))

        let presenter = UsersPresenter(dependencies: .init(model: model, router: router))

        let controller = UsersViewController(dependencies: .init(presenter: presenter))
        router.setRootController(controller: controller)

        return controller
    }
}
