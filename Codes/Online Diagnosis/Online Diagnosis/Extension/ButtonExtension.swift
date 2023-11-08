//
//  ButtonExtension.swift
//  Online Diagnosis
//
//

import UIKit

class ButtonLayerSetup: UIButton{
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
