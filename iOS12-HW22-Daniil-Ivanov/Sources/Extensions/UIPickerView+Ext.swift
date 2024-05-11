//
//  UIPickerView+Ext.swift
//  iOS12-HW22-Daniil-Ivanov
//
//  Created by Daniil (work) on 06.05.2024.
//

import UIKit

extension UIPickerView {
    func setComponentBackgroundColor(_ color: UIColor) {
        subviews.last?.backgroundColor = color
    }
}
