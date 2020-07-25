//
//  PriceTextField.swift
//  Menu
//
//  Created by Kurt Kim on 2020-06-23.
//  Copyright © 2020 Kurt Kim. All rights reserved.
//

import UIKit

class PriceTextField: UITextField {
    
    var userInput = ""
    var delete = false
    var locale = Locale(identifier: "en_US")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }

    private func setupTextField() {
        self.placeholder = "$0.00"
        self.keyboardType = .numberPad
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    override func deleteBackward() {
        userInput = String(userInput.dropLast())
        text = userInput.asCurrency(locale: locale)
        delete = true
        super.deleteBackward()
    }

    @objc func editingChanged() {
        defer {
            delete = false
            text = userInput.asCurrency(locale: locale)
        }

        guard delete == false else { return }

        if let lastEnteredCharacter = text?.last, lastEnteredCharacter.isNumber {
            userInput.append(lastEnteredCharacter)
        }
    }
}

private extension Formatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
}

private extension String {
    func asCurrency(locale: Locale) -> String? {
        Formatter.currency.locale = locale
        if self.isEmpty {
            return Formatter.currency.string(from: NSNumber(value: 0))
        } else {
            return Formatter.currency.string(from: NSNumber(value: (Double(self) ?? 0) / 100))
        }
    }
}
