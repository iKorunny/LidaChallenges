//
//  OffsetsService.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 7/16/24.
//

import Foundation
import UIKit

final class OffsetsService {
    static let shared = OffsetsService()
    
    var bannerView: UIView?
    
    var myChallengesButtonHeight: CGFloat {
        85
    }
    
    var bottomOffset: CGFloat {
        myChallengesButtonHeight + (bannerView?.bounds.height ?? 0)
    }
}
