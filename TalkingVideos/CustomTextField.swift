//
//  ProjectCell.swift
//  TalkingVideos
//
//  Created by Nisha Gupta on 03/04/25.
//

import UIKit

class CustomTextField: UITextField {

    // Define a property for the placeholder color
    @IBInspectable var placeholderColor: UIColor = .white {
        didSet {
            updatePlaceholder()
        }
    }

    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    private func updatePlaceholder() {
        guard let placeholderText = placeholder else { return }
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }
}
