//
//  Router.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 26.04.2024.
//

import UIKit

final class Router {
    private var controller: UIViewController?

    func setRootController(controller: UIViewController) {
        self.controller = controller
    }

    func goToUserDetails(_ user: User) {
        let userDetails = UserDetailsModuleAssembly.build(with: .init(user: user))

        self.controller?.navigationController?.pushViewController(userDetails, animated: true)
    }

    func goBack() {
        self.controller?.navigationController?.popViewController(animated: true)
    }
}
