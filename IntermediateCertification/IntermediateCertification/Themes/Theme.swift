//
//  Theme.swift
//  IntermediateCertification
//
//  Created by Ринат on 03.09.2023.
//

import UIKit

enum ThemeTypes: String {
    case whiteTheme = "white"
    case blueTheme = "blue"
    case greenTheme = "green"
}

protocol AppThemeProtocol {
    var type: ThemeTypes { get set }
    var backgroundColor: UIColor { get }
}

final class Theme {
    static var currentTheme: AppThemeProtocol = WhiteTheme()
}

final class WhiteTheme: AppThemeProtocol {
    var type: ThemeTypes = .whiteTheme
    var backgroundColor: UIColor = .white
}

final class BlueTheme: AppThemeProtocol {
    var type: ThemeTypes = .blueTheme
    var backgroundColor: UIColor = .blue
}

final class GreenTheme: AppThemeProtocol {
    var type: ThemeTypes = .greenTheme
    var backgroundColor: UIColor = .green
}
