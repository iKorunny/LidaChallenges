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
    var separator: UIColor { get }
    var ligthItem: UIColor { get }
    var warningItem: UIColor { get }
    var placeholder: UIColor { get }
    var listActionBackground: UIColor { get }
    var hint: UIColor { get }
    var pickerBackground: UIColor { get }
    var pickerBorder: UIColor { get }
}

final class LightTheme: ColorTheme {
    var mainBackground: UIColor { return .white }
    var itemBackground: UIColor { .white }
    var itemBackgroundHighlighted: UIColor { UIColor.color(from: "#E5E5E9") }
    var itemTextTitle: UIColor { .black }
    var separator: UIColor { UIColor.color(from: "#A9A9AC") }
    var ligthItem: UIColor { UIColor.color(from: "#A4A4A4") }
    var warningItem: UIColor { UIColor.color(from: "#888888") }
    var placeholder: UIColor { UIColor.color(from: "#606060") }
    var listActionBackground: UIColor { UIColor.color(from: "#E8E8E8") }
    var hint: UIColor { UIColor.color(from: "#699BF7") }
    var pickerBackground: UIColor { UIColor.color(from: "#C3C3C3") }
    var pickerBorder: UIColor { UIColor.color(from: "#4A4A4A") }
}
