//
//  DateTimePickerClass.swift
//  Bluelight
//
//  Created by Nisha Gupta on 06/05/24.
//

import UIKit


class DateTimePickerClass: UIDatePicker {
        
        private weak var textField: UITextField?
        
        init(textField: UITextField) {
            super.init(frame: .zero)
            self.textField = textField
            configurePicker()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configurePicker() {
            datePickerMode = .dateAndTime
            addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            
            if #available(iOS 13.4, *) {
                preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
        }
        
        @objc private func datePickerValueChanged() {
            guard let textField = textField else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            textField.text = dateFormatter.string(from: date)
        }
    }
