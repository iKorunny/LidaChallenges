//
//  ColorThemes.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/17/24.
//

import Foundation
import UIKit

protocol ColorTheme {
    var mainBackground: UIColor { get }
    var itemBackground: UIColor { get }
    var itemBackgroundHighlighted: UIColor { get }
    var itemTextTitle: UIColor { get }
    var itemSecondaryTextTitle: UIColor { get }
    var separator: UIColor { get }
    var ligthSeparator: UIColor { get }
    var ligthItem: UIColor { get }
    var warningItem: UIColor { get }
    var placeholder: UIColor { get }
    var listActionBackground: UIColor { get }
    var hint: UIColor { get }
    var pickerBackground: UIColor { get }
    var pickerBorder: UIColor { get }
    var buttonText: UIColor { get }
    var pickerButtonText: UIColor { get }
    var subtitle: UIColor { get }
    var itemBackgroundDisabled: UIColor { get }
    var textNotes: UIColor { get }
    var infoBright: UIColor { get }
    var defaultOverlay: UIColor { get }
    var popupBackground: UIColor { get }
    var popupSeparator: UIColor { get }
    var popupInfoText: UIColor { get }
}

final class LightTheme: ColorTheme {
    var mainBackground: UIColor { return .white }
    var itemBackground: UIColor { .white }
    var itemBackgroundHighlighted: UIColor { UIColor.color(from: "#E5E5E9") }
    var itemTextTitle: UIColor { .black }
    var itemSecondaryTextTitle: UIColor { UIColor.color(from: "#454545") }
    var separator: UIColor { UIColor.color(from: "#A9A9AC") }
    var ligthSeparator: UIColor { UIColor.color(from: "#A4A4A4") }
    var ligthItem: UIColor { UIColor.color(from: "#A4A4A4") }
    var warningItem: UIColor { UIColor.color(from: "#888888") }
    var placeholder: UIColor { UIColor.color(from: "#606060") }
    var listActionBackground: UIColor { UIColor.color(from: "#E8E8E8") }
    var hint: UIColor { UIColor.color(from: "#699BF7") }
    var pickerBackground: UIColor { UIColor.color(from: "#C3C3C3") }
    var pickerBorder: UIColor { UIColor.color(from: "#4A4A4A") }
    var buttonText: UIColor { UIColor.color(from: "#818181") }
    var pickerButtonText: UIColor { UIColor.color(from: "#707070") }
    var subtitle: UIColor { UIColor.color(from: "#7B7B7B") }
    var itemBackgroundDisabled: UIColor { UIColor.color(from: "#E7E7E7") }
    var textNotes: UIColor { UIColor.color(from: "#A9A9A9") }
    var infoBright: UIColor { UIColor.color(from: "#F10166") }
    var defaultOverlay: UIColor { UIColor.white.withAlphaComponent(0.5) }
    var popupBackground: UIColor { UIColor.color(from: "#D9D9D9").withAlphaComponent(0.5) }
    var popupSeparator: UIColor { UIColor.color(from: "#B0B0B0").withAlphaComponent(0.5) }
    var popupInfoText: UIColor { UIColor.color(from: "#898989") }
}
