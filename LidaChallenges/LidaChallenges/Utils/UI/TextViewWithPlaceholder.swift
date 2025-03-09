//
//  TextViewWithPlaceholder.swift
//  LidaChallenges
//
//  Created by Ihar Karunny on 10/7/24.
//

import UIKit

final class TextData {
    var text: String?
    var color: UIColor
    var font: UIFont
    
    init(text: String? = nil, color: UIColor, font: UIFont) {
        self.text = text
        self.color = color
        self.font = font
    }
}

final class TextViewWithPlaceholderDelegate: NSObject, UITextViewDelegate {
    weak var textView: TextViewWithPlaceholder?
    private var proxyDelegate: UITextViewDelegate
    
    init(textView: TextViewWithPlaceholder? = nil,
         proxyDelegate: UITextViewDelegate) {
        self.textView = textView
        self.proxyDelegate = proxyDelegate
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("TextViewWithPlaceholderDelegate: textViewDidChange")
        if textView.isFirstResponder {
            self.textView?.textData.text = textView.text
        }
        proxyDelegate.textViewDidChange?(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("TextViewWithPlaceholderDelegate: textViewDidEndEditing")
        if (self.textView?.textData.text?.count ?? 0) == 0 {
            textView.text = self.textView?.placeholderData?.text
            textView.font = self.textView?.placeholderData?.font
            textView.textColor = self.textView?.placeholderData?.color
        }
        proxyDelegate.textViewDidEndEditing?(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("TextViewWithPlaceholderDelegate: textViewDidBeginEditing")
        textView.text = self.textView?.textData.text
        textView.font = self.textView?.textData.font
        textView.textColor = self.textView?.textData.color
        proxyDelegate.textViewDidBeginEditing?(textView)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("TextViewWithPlaceholderDelegate: textViewShouldEndEditing")
        return proxyDelegate.textViewShouldEndEditing?(textView) ?? true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        print("TextViewWithPlaceholderDelegate: textViewDidChangeSelection")
        proxyDelegate.textViewDidChangeSelection?(textView)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("TextViewWithPlaceholderDelegate: textViewShouldBeginEditing")
        return proxyDelegate.textViewShouldBeginEditing?(textView) ?? true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("TextViewWithPlaceholderDelegate: shouldChangeTextIn")
        return proxyDelegate.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
}

final class TextViewWithPlaceholder: UITextView {
    var placeholderData: TextData?
    var textData: TextData
    private var delegateObject: TextViewWithPlaceholderDelegate?
    
    init(placeholderData: TextData?,
         textData: TextData = .init(color: ColorThemeProvider.shared.itemTextTitle, font: FontsProvider.regularAppFont(with: 16)),
         proxyDelegate: UITextViewDelegate) {
        self.placeholderData = placeholderData
        self.textData = textData
        
        super.init(frame: .zero, textContainer: nil)
        
        self.delegateObject = TextViewWithPlaceholderDelegate(textView: self, proxyDelegate: proxyDelegate)
        self.delegate = delegateObject
        
        if (textData.text?.count ?? 0) == 0 {
            text = placeholderData?.text
            font = placeholderData?.font
            textColor = placeholderData?.color
        }
        else {
            text = textData.text
            font = textData.font
            textColor = textData.color
        }
    }
    
    func set(text: String?) {
        textData.text = text
        
        if (textData.text?.count ?? 0) == 0 {
            self.text = placeholderData?.text
            font = placeholderData?.font
            textColor = placeholderData?.color
        }
        else {
            self.text = textData.text
            font = textData.font
            textColor = textData.color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
