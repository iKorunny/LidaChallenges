//
//  KeyboardAppearService.swift
//
//  Created by Ihar Karunny on 4/16/24.
//

import Foundation
import UIKit

final class KeyboardAppearService {
    private enum Constants {
        static let inputViewShowHideAnimationDuration: TimeInterval = 0.3
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private let mainView: UIView
    private let bottomConstraint: NSLayoutConstraint
    private let defaultBottomOffset: CGFloat
    private let appendDefaultOffset: Bool
    
    init(mainView: UIView,
         bottomConstraint: NSLayoutConstraint,
         appendDefaultOffset: Bool = false) {
        self.mainView = mainView
        self.bottomConstraint = bottomConstraint
        self.defaultBottomOffset = bottomConstraint.constant
        self.appendDefaultOffset = appendDefaultOffset
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        reset()
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard  let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        var keyboardHeight = keyboardRectangle.height
        
        if !appendDefaultOffset {
            keyboardHeight += defaultBottomOffset
        }
        
        onShowInputView(with: keyboardHeight)
    }
    
    func onShowInputView(with height: CGFloat) {
        bottomConstraint.constant = -height
        UIView.animate(withDuration: Constants.inputViewShowHideAnimationDuration) { [weak self] in
            if self?.mainView.window == nil {
                self?.mainView.setNeedsLayout()
            }
            else {
                self?.mainView.layoutIfNeeded()
            }
        } completion: { _ in
            
        }
    }
    
    func reset() {
        bottomConstraint.constant = defaultBottomOffset
        UIView.animate(withDuration: Constants.inputViewShowHideAnimationDuration) { [weak self] in
            self?.mainView.layoutIfNeeded()
        }
    }
}
