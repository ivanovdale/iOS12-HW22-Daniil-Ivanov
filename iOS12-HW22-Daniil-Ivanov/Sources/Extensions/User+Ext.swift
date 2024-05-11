//
//  User+Presentable.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 03.05.2024.
//

import Foundation

extension User {
    override var description: String {
        let properties: [String?] = [name, surname]

        return properties.compactMap( {$0}).joined(separator: " ")
    }
}

extension User {
    var genderValue: Gender {
        get {
            return Gender(rawValue: self.gender ?? "other") ?? .other
        }
        set {
            self.gender = String(newValue.rawValue)
        }
    }
}
