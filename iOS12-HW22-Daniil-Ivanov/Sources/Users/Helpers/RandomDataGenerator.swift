//
//  RandomDataGenerator.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 29.04.2024.
//

import Foundation

protocol RandomDataGeneratorProtocol {
    static var birthdayLowerBound: Date { get }
    static var birthdayUpperBound: Date { get }
    func randomSurname() -> String
    func randomBirthday() -> Date
    func randomGender() -> Gender
}

final class RandomDataGenerator: RandomDataGeneratorProtocol {

    private static let currentDate = Date()

    static var birthdayLowerBound: Date {
        Calendar.current.date(byAdding: .year, value: -80, to: currentDate)!
    }

    static var birthdayUpperBound: Date {
        Calendar.current.date(byAdding: .year, value: -18, to: currentDate)!
    }

    // Array of sample surnames
    let surnames = ["Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor"]

    // Generate a random surname
    func randomSurname() -> String {
        return surnames.randomElement() ?? "Doe"
    }

    // Generate a random birthday between 18 and 80 years ago
    func randomBirthday() -> Date {
        let lowerBound = RandomDataGenerator.birthdayLowerBound
        let upperBound = RandomDataGenerator.birthdayUpperBound
        let randomInterval = TimeInterval.random(in: lowerBound.timeIntervalSinceReferenceDate...upperBound.timeIntervalSinceReferenceDate)
        return Date(timeIntervalSinceReferenceDate: randomInterval)
    }

    // Generate a random gender (male, female, or other)
    func randomGender() -> Gender {
        let genders: [Gender] = [.male, .female, .other]
        return genders.randomElement() ?? .other
    }
}
