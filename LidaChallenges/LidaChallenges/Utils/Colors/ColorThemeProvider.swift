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
    var itemSecondaryTextTitle: UIColor { currentTheme.itemSecondaryTextTitle }
    var separator: UIColor { currentTheme.separator }
    var ligthSeparator: UIColor { currentTheme.ligthSeparator }
    var ligthItem: UIColor { currentTheme.ligthItem }
    var warningItem: UIColor { currentTheme.warningItem }
    var placeholder: UIColor { currentTheme.placeholder }
    var listActionBackground: UIColor { currentTheme.listActionBackground }
    var hint: UIColor { currentTheme.hint }
    var pickerBackground: UIColor { currentTheme.pickerBackground }
    var pickerBorder: UIColor { currentTheme.pickerBorder }
    var buttonText: UIColor { currentTheme.buttonText }
    var pickerButtonText: UIColor { currentTheme.pickerButtonText }
    var subtitle: UIColor { currentTheme.subtitle }
    var itemBackgroundDisabled: UIColor { currentTheme.itemBackgroundDisabled }
    var textNotes: UIColor { currentTheme.textNotes }
    var infoBright: UIColor { currentTheme.infoBright }
    var defaultOverlay: UIColor { currentTheme.defaultOverlay }
    var popupBackground: UIColor { currentTheme.popupBackground }
    var popupSeparator: UIColor { currentTheme.popupSeparator }
    var popupInfoText: UIColor { currentTheme.popupInfoText }
}
