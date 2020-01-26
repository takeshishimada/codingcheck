//
//  UITextView-Extension.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/22.
//  Copyright © 2020 Cactacea. All rights reserved.
//

import UIKit

extension UITextView {
    
    var selectedText: String {
        let location = self.selectedRange.location
        let length = self.selectedRange.length
        let selectedText = (self.text as NSString).substring(with: NSRange(location:location,length: length))
        return selectedText
    }
    func insertEnclosureString(_ text: String) {
        let replaceText = text + self.selectedText + text
        self.insertText(replaceText)
    }
}
