//
//  DatabaseManager.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 26.04.2024.
//

import CoreData

typealias DatabaseActionClosure = (DatabaseAction?) -> Void

protocol UsersDatabaseManager {
    var savedEntities: [User] { get set }

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

    var onChanged: DatabaseActionClosure? { get set }
}

final class UsersCoreDataManager: UsersDatabaseManager {
    private let container: NSPersistentContainer
    private var currentAction: DatabaseAction?
    var savedEntities: [User] = []
    var onChanged: DatabaseActionClosure?

    init() {
        container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores { description, error in
            if let error {
                print("Unable to load Database, error \(error))")
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
        currentAction = .add
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
        currentAction = .update
        saveData()
    }

    func deleteUser(_ user: User) {
        container.viewContext.delete(user)
        currentAction = .delete
        saveData()
    }

    private func saveData() {
        do {
            try container.viewContext.save()
            fetchUsers()
            onChanged?(currentAction)
            currentAction = nil
        } catch {
            print("Can not save data, error: \(error.localizedDescription)")
        }
    }
}

enum DatabaseAction {
    case add, delete, update
}
