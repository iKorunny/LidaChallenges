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
}

final class LightTheme: ColorTheme {
    var mainBackground: UIColor { return .white }
    var itemBackground: UIColor { .white }
    var itemBackgroundHighlighted: UIColor { UIColor.color(from: "#E5E5E9") }
    var itemTextTitle: UIColor { .black }
}
