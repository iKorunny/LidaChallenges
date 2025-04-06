//
//  UIImage+Utils.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 8/1/24.
//

import Foundation
import UIKit

extension UIImage {
    func imageWith(newSize: CGSize, scale: CGFloat, round: Bool = false) -> UIImage {
        var image: UIImage!
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        
        if round {
            let radius = min(newSize.width, newSize.height) * 0.5
            image = UIGraphicsImageRenderer(size: newSize, format: format).image { context in
                let rect = CGRect(origin: .zero, size: newSize)
                let path = UIBezierPath(roundedRect: rect,
                                        byRoundingCorners: .allCorners,
                                        cornerRadii: CGSize(width: radius, height: radius))
                path.close()
                
                let cgContext = context.cgContext
                cgContext.saveGState()
                path.addClip()
                draw(in: rect)
                cgContext.restoreGState()
            }
        }
        else {
            image = UIGraphicsImageRenderer(size: newSize).image { _ in
                draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
        
        return image.withRenderingMode(renderingMode)
    }
    
    static func image(with color: UIColor) -> UIImage? {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
