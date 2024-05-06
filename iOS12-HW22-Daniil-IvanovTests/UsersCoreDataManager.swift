//
//  iOS12_HW22_Daniil_IvanovTests.swift
//  iOS12-HW22-Daniil-IvanovTests
//
//  Created by Daniil (work) on 26.04.2024.
//

import XCTest
import CoreData
@testable import iOS12_HW22_Daniil_Ivanov

final class UsersCoreDataManagerTest: XCTestCase {

    var coreDataManager: UsersCoreDataManager!

    override func setUp() {
        super.setUp()
        coreDataManager = UsersCoreDataManager()
    }

    override func tearDown() {
        coreDataManager = nil
        super.tearDown()
    }

    func testFetchUsers() {
        // Assuming there are users already stored in the database
        coreDataManager.fetchUsers()
        XCTAssertFalse(coreDataManager.savedEntities.isEmpty, "Failed to fetch users")
    }

    func testAddUser() {
        let initialCount = coreDataManager.savedEntities.count
        coreDataManager.addUser(name: "John", surname: "Doe", birthday: Date(), gender: "Male")
        coreDataManager.fetchUsers()
        XCTAssertEqual(coreDataManager.savedEntities.count, initialCount + 1, "Failed to add user")
    }

    func testUpdateUser() {
        coreDataManager.fetchUsers()
        guard let userToUpdate = coreDataManager.savedEntities.first else {
            XCTFail("No user found to update")
            return
        }

        let newName = "Jane"
        let newSurname = "Smith"
        coreDataManager.updateUser(user: userToUpdate, name: newName, surname: newSurname, birthday: userToUpdate.birthday ?? Date(), gender: userToUpdate.gender ?? "")

        coreDataManager.fetchUsers()
        guard let updatedUser = coreDataManager.savedEntities.first(where: { $0.name == newName && $0.surname == newSurname }) else {
            XCTFail("User not updated")
            return
        }
        XCTAssertEqual(updatedUser.name, newName)
        XCTAssertEqual(updatedUser.surname, newSurname)
    }

    func testDeleteUser() {
        coreDataManager.fetchUsers()
        guard let userToDelete = coreDataManager.savedEntities.first else {
            XCTFail("No user found to delete")
            return
        }

        let initialCount = coreDataManager.savedEntities.count
        coreDataManager.deleteUser(userToDelete)
        coreDataManager.fetchUsers()
        XCTAssertEqual(coreDataManager.savedEntities.count, initialCount - 1, "Failed to delete user")
    }

    func testOnChangeClosure() {
        let expectation = XCTestExpectation(description: "Database action closure called")

        coreDataManager.onChanged = { action in
            XCTAssertNotNil(action)
            expectation.fulfill()
        }

        coreDataManager.addUser(name: "Test", surname: "User", birthday: Date(), gender: "Other")

        wait(for: [expectation], timeout: 1.0)
    }
}
