//
//  UserDetailsView.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 03.05.2024.
//

import UIKit
import SnapKit

protocol UserDetailsViewProtocol: AnyObject {

    // MARK: - Handlers

    var onBackButtonPressedHandler: (() -> Void)? { get set }
    var onEditSaveButtonPressedHandler: (() -> Void)? { get set }
    var onGenderChosenHandler: ((Gender) -> Void)? { get set }

    // MARK: - Gender values

    var possibleGenders: [Gender] { get set }

    // MARK: - Birthday ranges

    func setPossibleBirthdayRanges(dateRange: DateRange)

    // MARK: - UI update

    func updateNameSurnameTextField(data: String)
    func updateBirthdayDatePicker(data: Date)
    func updateGenderPicker(rowNumber: Int)
    func setGenderPickerStyle(isEditingMode: Bool)
    func lockFields()
    func unlockFields()
    func setEditSaveButtonStyle(isEditingMode: Bool)

    // MARK: - Fields value getters

    func getNameSurnameTextFieldText() -> String
    func getBirthdayDatePickerValue() -> Date

    // MARK: - Error alert

    func configureErrorAlert(message: String) -> UIAlertController
}

final class UserDetailsView: UIView {

    // MARK: - Handlers

    var onBackButtonPressedHandler: (() -> Void)?
    var onEditSaveButtonPressedHandler: (() -> Void)?
    var onGenderChosenHandler: ((Gender) -> Void)?

    // MARK: - Gender values

    var possibleGenders: [Gender] = [] {
        didSet {
            genderPicker.reloadComponent(0)
        }
    }

    // MARK: - Outlets

    // MARK: Buttons

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.left")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.systemGray)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(onBackButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var editSaveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.setTitleColor(UIColor.systemGray, for: .normal)
        button.addTarget(self, action: #selector(onEditSaveButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Avatar

    private lazy var avatarImage: UIImageView = {
        let image = UIImage(named: "drive")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 200 / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: NameSurname

    private lazy var nameSurnameIcon: UIImageView = {
        let image = UIImage(systemName: "person")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.label)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var nameSurnameTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .asciiCapable
        textField.placeholder = "Enter your name and surname"
        textField.tintColor = .systemGray
        return textField
    }()

    private lazy var nameSurnameTextFieldSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()

    // MARK: Birthday

    private lazy var birthdayIcon: UIImageView = {
        let image = UIImage(systemName: "calendar")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.label)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var birthdayDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        return datePicker
    }()

    private lazy var birthdayLabelSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()

    // MARK: Gender

    private lazy var genderIcon: UIImageView = {
        let image = UIImage(systemName: "person.2.circle")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.label)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var genderTitle: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.textColor = .label
        return label
    }()

    private lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupHierarchy() {
        [
            backButton,
            editSaveButton,
            avatarImage,
            nameSurnameIcon,
            nameSurnameTextField,
            nameSurnameTextFieldSeparator,
            birthdayIcon,
            birthdayDatePicker,
            birthdayLabelSeparator,
            genderIcon,
            genderTitle,
            genderPicker,
        ].forEach { addSubview($0) }
    }

    private func setupLayout() {
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(18)
            make.top.equalTo(self.safeAreaLayoutGuide).offset(40)
        }

        editSaveButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-18)
            make.centerY.equalTo(backButton.snp.centerY)
            make.width.equalTo(90)
            make.height.equalTo(40)
        }

        avatarImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(editSaveButton.snp_bottomMargin).offset(60)
            make.height.width.equalTo(200)
        }

        nameSurnameIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalTo(avatarImage.snp_bottomMargin).offset(40)
            make.height.width.equalTo(30)
        }

        nameSurnameTextField.snp.makeConstraints { make in
            make.leading.equalTo(nameSurnameIcon.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-18)
            make.top.equalTo(avatarImage.snp_bottomMargin).offset(36)
            make.height.equalTo(44)
        }

        nameSurnameTextFieldSeparator.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalTo(nameSurnameIcon.snp_bottomMargin).offset(30)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(0.5)
        }

        birthdayIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalTo(nameSurnameTextFieldSeparator.snp_bottomMargin).offset(40)
            make.height.width.equalTo(30)
        }

        birthdayDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(birthdayIcon.snp.trailing).offset(3)
            make.centerY.equalTo(birthdayIcon.snp.centerY)
        }

        birthdayLabelSeparator.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalTo(birthdayIcon.snp_bottomMargin).offset(30)
            make.trailing.equalToSuperview().offset(-18)
            make.height.equalTo(0.5)
        }

        genderIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(18)
            make.top.equalTo(birthdayLabelSeparator.snp_bottomMargin).offset(40)
            make.height.width.equalTo(30)
        }

        genderTitle.snp.makeConstraints { make in
            make.leading.equalTo(genderIcon.snp.trailing).offset(15)
            make.centerY.equalTo(genderIcon.snp.centerY)
        }

        genderPicker.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-18)
            make.centerY.equalTo(genderIcon.snp.centerY)
            make.width.equalTo(120)
            make.height.equalTo(100)
        }
    }

    private func setupView() {
        backgroundColor = .systemBackground
        setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(gesture)
    }
}

// MARK: - UserDetailsViewProtocol

extension UserDetailsView: UserDetailsViewProtocol {
    func updateNameSurnameTextField(data: String) {
        nameSurnameTextField.text = data
    }

    func setPossibleBirthdayRanges(dateRange: DateRange) {
        birthdayDatePicker.minimumDate = dateRange.min
        birthdayDatePicker.maximumDate = dateRange.max
    }

    func updateBirthdayDatePicker(data: Date) {
        birthdayDatePicker.date = data
    }
    
    func updateGenderPicker(rowNumber: Int) {
        genderPicker.selectRow(rowNumber, inComponent: 0, animated: false)
    }

    func setGenderPickerStyle(isEditingMode: Bool) {
        genderPicker.setComponentBackgroundColor(isEditingMode ? .quaternarySystemFill : .clear)
    }

    func lockFields() {
        nameSurnameTextField.isEnabled = false
        birthdayDatePicker.isEnabled = false
        genderPicker.isUserInteractionEnabled = false
    }

    func unlockFields() {
        nameSurnameTextField.isEnabled = true
        birthdayDatePicker.isEnabled = true
        genderPicker.isUserInteractionEnabled = true
    }

    func setEditSaveButtonStyle(isEditingMode: Bool) {
        editSaveButton.setTitle(isEditingMode ? "Save" : "Edit", for: .normal)
        editSaveButton.setTitleColor(isEditingMode ? .white : .systemGray, for: .normal)
        editSaveButton.backgroundColor = isEditingMode ? .systemBlue : .white
        editSaveButton.layer.borderColor = isEditingMode ? UIColor.systemBlue.cgColor : UIColor.label.cgColor
    }

    func getNameSurnameTextFieldText() -> String {
        nameSurnameTextField.text ?? ""
    }

    func getBirthdayDatePickerValue() -> Date {
        birthdayDatePicker.date
    }

    // MARK: Error alert

    func configureErrorAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error saving data",
                                      message: message,
                                      preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "Cancel",
                                        style: .cancel,
                                        handler: nil)
        alert.addAction(alertAction)
        return alert
    }
}

// MARK: - Private methods

private extension UserDetailsView {

    // MARK: Actions

    @objc func onBackButtonTapped() {
        self.onBackButtonPressedHandler?()
    }

    @objc func onEditSaveButtonTapped() {
        self.onEditSaveButtonPressedHandler?()
    }

    @objc
    func viewTapped(sender: UITapGestureRecognizer){
        self.endEditing(true)
    }
}

// MARK: - UIPickerViewDelegate

extension UserDetailsView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return possibleGenders[row].rawValue.capitalized
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let gender = possibleGenders[row]
        onGenderChosenHandler?(gender)
    }
}

// MARK: - UIPickerViewDataSource

extension UserDetailsView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        possibleGenders.count
    }
}
