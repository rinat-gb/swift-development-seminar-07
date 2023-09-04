//
//  ThemeView.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit

protocol ThemeViewDelegate: AnyObject {
    func updateTheme()
}

final class ThemeView: UIView {
    weak var delegate: ThemeViewDelegate?

    private var themeTitle: UILabel = {
        let label = UILabel()

        label.text = "Выберите цвет темы:"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    private var themeWhiteButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = WhiteTheme().backgroundColor
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15
        return button
    }()

    private var themeBlueButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = BlueTheme().backgroundColor
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15
        return button
    }()

    private var themeGreenButton: UIButton = {
        let button = UIButton()

        button.backgroundColor = GreenTheme().backgroundColor
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15
        return button
    }()

    init() {
        super.init(frame: .zero)

        backgroundColor = Theme.currentTheme.backgroundColor

        themeWhiteButton.addTarget(self, action: #selector(tapThemeWhite), for: .touchUpInside)
        themeBlueButton.addTarget(self, action: #selector(tapThemeBlue), for: .touchUpInside)
        themeGreenButton.addTarget(self, action: #selector(tapThemeGreen), for: .touchUpInside)

        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(themeTitle)
        addSubview(themeWhiteButton)
        addSubview(themeBlueButton)
        addSubview(themeGreenButton)
    }

    private func setupConstraints() {
        themeTitle.translatesAutoresizingMaskIntoConstraints = false
        themeWhiteButton.translatesAutoresizingMaskIntoConstraints = false
        themeBlueButton.translatesAutoresizingMaskIntoConstraints = false
        themeGreenButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            themeTitle.topAnchor.constraint(equalTo: topAnchor),
            themeTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            themeTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeTitle.trailingAnchor.constraint(equalTo: trailingAnchor),

            themeBlueButton.topAnchor.constraint(equalTo: themeTitle.bottomAnchor, constant: 70),
            themeWhiteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            themeWhiteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            themeWhiteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            themeBlueButton.topAnchor.constraint(equalTo: themeWhiteButton.bottomAnchor, constant: 20),
            themeBlueButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            themeBlueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            themeBlueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),

            themeGreenButton.topAnchor.constraint(equalTo: themeBlueButton.bottomAnchor, constant: 20),
            themeGreenButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            themeGreenButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            themeGreenButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
    }

    @objc private func tapThemeWhite() {
        Theme.currentTheme = WhiteTheme()
        backgroundColor = Theme.currentTheme.backgroundColor
        delegate?.updateTheme()
    }

    @objc private func tapThemeBlue() {
        Theme.currentTheme = BlueTheme()
        backgroundColor = Theme.currentTheme.backgroundColor
        delegate?.updateTheme()
    }

    @objc private func tapThemeGreen() {
        Theme.currentTheme = GreenTheme()
        backgroundColor = Theme.currentTheme.backgroundColor
        delegate?.updateTheme()
    }
}
