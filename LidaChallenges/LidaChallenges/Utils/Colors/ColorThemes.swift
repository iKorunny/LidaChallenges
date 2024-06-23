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
    var itemTextTitle: UIColor { get }
}

final class LightTheme: ColorTheme {
    var mainBackground: UIColor { return .white }
    var itemBackground: UIColor { .white }
    var itemTextTitle: UIColor { .black }
}
