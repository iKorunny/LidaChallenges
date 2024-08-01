//
//  ColorThemeProvider.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/17/24.
//

import Foundation
import UIKit

final class ColorThemeProvider: ColorTheme {
    static let shared = ColorThemeProvider()
    
    private var currentTheme: ColorTheme = LightTheme()
    
    var mainBackground: UIColor { currentTheme.mainBackground }
    var itemBackground: UIColor { currentTheme.itemBackground }
    var itemBackgroundHighlighted: UIColor { currentTheme.itemBackgroundHighlighted }
    var itemTextTitle: UIColor { currentTheme.itemTextTitle }
    var separator: UIColor { currentTheme.separator }
    var ligthItem: UIColor { currentTheme.ligthItem }
    var warningItem: UIColor { currentTheme.warningItem }
    var placeholder: UIColor { currentTheme.placeholder }
    var listActionBackground: UIColor { currentTheme.listActionBackground }
    var hint: UIColor { currentTheme.hint }
    var pickerBackground: UIColor { currentTheme.pickerBackground }
    var pickerBorder: UIColor { currentTheme.pickerBorder }
    var buttonText: UIColor { currentTheme.buttonText }
    var pickerButtonText: UIColor { currentTheme.pickerButtonText }
}
