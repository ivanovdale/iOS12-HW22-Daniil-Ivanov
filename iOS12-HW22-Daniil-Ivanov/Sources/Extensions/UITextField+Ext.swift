//
//  UITextField+Ext.swift
//  iOS12-HW21-Daniil-Ivanov
//
//  Created by Daniil (work) on 19.04.2024.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let frame = CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height)
        let paddingView = UIView(frame: frame)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
