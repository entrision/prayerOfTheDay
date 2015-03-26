//
//  UIColorExtensions.swift
//  AidTree-iOS
//
//  Created by Travis Wade on 12/30/14.
//  Copyright (c) 2014 Travis Wade. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red)/255.0,
            green: CGFloat(green)/255.0,
            blue: CGFloat(blue)/255.0,
            alpha: 1.0
        )
    }
}
