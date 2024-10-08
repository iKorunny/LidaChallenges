//
//  FontsProvider.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/15/24.
//

import Foundation
import UIKit

final class FontsProvider {
    /**
        500
     */
    static func mediumAppFont(with size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    /**
        400
     */
    static func regularAppFont(with size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    /**
        300
     */
    static func lightAppFont(with size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .light)
    }
}
