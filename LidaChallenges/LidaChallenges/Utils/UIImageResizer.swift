//
//  UIImageResizer.swift
//  YOUUtils
//
//  Created by Ihar Karunny on 3/17/24.
//

import Foundation
import UIKit

final class UIImageResizer {
    static func resizeTo1080p(image: UIImage, scale: CGFloat, round: Bool = false) -> UIImage {
        let targetSize: CGSize = .init(width: 1920, height: 1080)
        return resize(image: image, to: targetSize,
                      scale: scale,
                      round: round)
    }
    
    static func resizeTo720p(image: UIImage, scale: CGFloat, round: Bool = false) -> UIImage {
        let targetSize: CGSize = .init(width: 1280, height: 720)
        return resize(image: image, to: targetSize,
                      scale: scale,
                      round: round)
    }
    
    static func resize(image: UIImage, to targetSize: CGSize, scale: CGFloat, round: Bool = false) -> UIImage {
        let scaleFactor = max(image.size.width / targetSize.width,
                              image.size.height / targetSize.height)
        
        if round {
            let dimension = min(image.size.width / scaleFactor, image.size.height / scaleFactor)
            return image.imageWith(newSize: CGSize(width: dimension,
                                                   height: dimension),
                                   scale: scale, round: round)
        }
        else {
            return image.imageWith(newSize: CGSize(width: image.size.width / scaleFactor,
                                                   height: image.size.height / scaleFactor),
                                   scale: scale,
                                   round: round)
        }
    }
}
