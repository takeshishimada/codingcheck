//
//  BorderButton.swift
//  codingcheck
//
//  Created by TAKESHI SHIMADA on 2020/01/22.
//  Copyright © 2020 Cactacea. All rights reserved.
//
import UIKit

@IBDesignable
class BorderButton: UIButton {
     
    @IBInspectable var textColor: UIColor?
     
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
     
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
     
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
