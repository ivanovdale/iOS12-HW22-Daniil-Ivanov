//
//  DatabaseManager.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 26.04.2024.
//

import CoreData

// MARK: - Typealias

typealias VoidClosure = () -> Void

// MARK: - Protocol

protocol UserDatabaseManager {
    func fetchUsers()

    func addUser(name: String,
                 surname: String,
                 birthday: Date,
                 gender: String)

    func updateUser(user: User,
                    name: String,
                    surname: String,
                    birthday: Date,
                    gender: String)

    func deleteUser(_ user: User)

    var onChanged: VoidClosure? { get set }
}

// MARK: - Implementation

final class UserCoreDataManager: UserDatabaseManager {
    private let container: NSPersistentContainer
    var savedEntities: [User] = []
    var onChanged: VoidClosure?

    init() {
        container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores { description, error in
            if let error {
                print("Unable to load Database")
            } else {
                print("Database loaded")
            }
        }
        fetchUsers()
    }

    func fetchUsers() {
        let request = NSFetchRequest<User>(entityName: "User")

        do {
            savedEntities = try container.viewContext.fetch(request)
            onChanged?()
        } catch {
            print("Unable to load users, error: \(error.localizedDescription)")
        }
    }

    func addUser(name: String,
                 surname: String,
                 birthday: Date, 
                 gender: String) {
        let newUser = User(context: container.viewContext)
        newUser.name = name
        newUser.surname = surname
        newUser.birthday = birthday
        newUser.gender = gender
        saveData()
    }

    func updateUser(user: User,
                    name: String,
                    surname: String,
                    birthday: Date,
                    gender: String) {
        user.name = name
        user.surname = surname
        user.birthday = birthday
        user.gender = gender
        saveData()
    }

    func deleteUser(_ user: User) {
        container.viewContext.delete(user)
        saveData()
    }

    private func saveData() {
        do {
            try container.viewContext.save()
            fetchUsers()
        } catch {
            print("Can not save data, error: \(error.localizedDescription)")
        }
    }
}
