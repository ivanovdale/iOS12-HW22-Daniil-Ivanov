//
//  UserDetailsPresenter.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 03.05.2024.
//

import Foundation

typealias ValidationResult = (value: Bool, error: String?)

protocol UserDetailsPresenterProtocol {
    func loadView(controller: UserDetailsViewController, view: UserDetailsViewProtocol)
}

final class UserDetailsPresenter {
    struct Dependencies {
        let model: UserDetailsModelProtocol
        let router: Router
    }

    private weak var controller: UserDetailsViewController?
    private weak var view: UserDetailsViewProtocol?

    // MARK: - Dependencies

    private var model: UserDetailsModelProtocol
    private let router: Router

    // MARK: - Presentation logic fields

    private var isEditingMode = false {
        didSet {
            setEditSaveButtonStyle()
            setGenderPickerStyle()
            setupPossibleGenders()
            setGenderPickerData()
            setFieldsAvailability()
            saveChangesIfNeeded()
        }
    }

    private var chosenGender: Gender?

    // MARK: - Init

    init(dependencies: Dependencies) {
        self.model = dependencies.model
        self.router = dependencies.router
    }
}

// MARK: - UserDetailsPresenterProtocol

extension UserDetailsPresenter: UserDetailsPresenterProtocol {
    func loadView(controller: UserDetailsViewController, view: UserDetailsViewProtocol) {
        self.controller = controller
        self.view = view

        // MARK: Handlers

        setHandlers()

        // MARK: Set initial data

        setNameSurnameTextFieldData()
        setBirthdayLabelData()
        setBirthdayRanges()
        setInitialGenderData()
        setupPossibleGenders()
        setGenderPickerData()

        // MARK: Set style

        setEditSaveButtonStyle()
        setGenderPickerStyle()
        setFieldsAvailability()
    }
}

// MARK: - Private methods

private extension UserDetailsPresenter {

    // MARK: - Presentation logic

    // MARK: Editing mode

    func toggleEditingMode() {
        isEditingMode = !isEditingMode
    }

    // MARK: Saving data

    func saveChangesIfNeeded() {
        guard let view else { return }
        let isDataChanged = model.user.description != view.getNameSurnameTextFieldText() ||
                            model.user.birthday != view.getBirthdayDatePickerValue() ||
                            model.user.genderValue != chosenGender

        if !isEditingMode && isDataChanged {
            saveChanges()
        }
    }

    func saveChanges() {
        guard let view, let controller else { return }
        let nameSurnameData = view.getNameSurnameTextFieldText().components(separatedBy: " ")
        let validationResult = isDataValid(nameSurnameData: nameSurnameData)
        guard validationResult.value,
              let name = nameSurnameData.first,
              let surname = nameSurnameData.last,
              let chosenGender else {
            controller.present(view.configureErrorAlert(message: validationResult.error ?? ""), animated: true)
            isEditingMode = true
            return
        }

        let birthday = view.getBirthdayDatePickerValue()
        model.updateUser(name: name, 
                         surname: surname,
                         birthday: birthday,
                         gender: chosenGender.rawValue)
    }

    func isDataValid(nameSurnameData: [String]) -> ValidationResult {
        guard nameSurnameData.count == 2 else {
            return (false, "Name and surname must consist of 2 words")
        }

        return (true, nil)
    }

    // MARK: NameSurname, birthday

    func setNameSurnameTextFieldData() {
        guard let view else { return }
        view.updateNameSurnameTextField(data: model.user.description)
    }

    func setBirthdayLabelData() {
        guard let view,
              let birthday = model.user.birthday else { return }
        view.updateBirthdayDatePicker(data: birthday)
    }

    func setBirthdayRanges() {
        guard let view else { return }
        let range = model.getBirthdayRange()
        view.setPossibleBirthdayRanges(dateRange: range)
    }

    // MARK: Gender

    func setInitialGenderData() {
        chosenGender = model.user.genderValue
    }

    func setupPossibleGenders() {
        guard let view, let chosenGender else { return }
        view.possibleGenders = isEditingMode ? Gender.allCases : [chosenGender]
    }

    func setGenderPickerData() {
        guard let view,
              let chosenGender,
              let rowNumber = view.possibleGenders.firstIndex(of: chosenGender) else { return }
        view.updateGenderPicker(rowNumber: rowNumber)
    }

    func setGenderPickerStyle() {
        guard let view else { return }
        view.setGenderPickerStyle(isEditingMode: isEditingMode)
    }

    // MARK: Buttons style

    func setEditSaveButtonStyle() {
        guard let view else { return }
        view.setEditSaveButtonStyle(isEditingMode: isEditingMode)
    }

    // MARK: Fields availability

    func setFieldsAvailability() {
        guard let view else { return }
        if isEditingMode {
            view.unlockFields()
        } else {
            view.lockFields()
        }
    }

    // MARK: - Handlers

    func setHandlers() {
        guard let view else { return }
        view.onBackButtonPressedHandler = { [weak self] in
            guard let self else { return }
            router.goBack()
        }

        view.onEditSaveButtonPressedHandler = { [weak self] in
            guard let self else { return }
            toggleEditingMode()
        }

        view.onGenderChosenHandler = { [weak self] gender in
            guard let self else { return }
            chosenGender = gender
        }
    }
}
