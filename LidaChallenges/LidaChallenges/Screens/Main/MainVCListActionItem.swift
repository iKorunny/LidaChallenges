//
//  MainVCListActionItem.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 6/24/24.
//

import Foundation
import UIKit

final class MainVCListActionItem {
    let image: UIImage
    let title: String
    let action: ((MainVCListActionItem) -> Void)
    
    init(image: UIImage, title: String, action: @escaping (MainVCListActionItem) -> Void) {
        self.image = image
        self.title = title
        self.action = action
    }
}
