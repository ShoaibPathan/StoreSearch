//
//  UIView+CornerRadius.swift
//  StoreSearch
//
//  Created by Ufuk Canlı on 4.09.2020.
//  Copyright © 2020 Ufuk Canlı. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
