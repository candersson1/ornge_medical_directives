//
//  String+HTML.swift
//  OntarioMedic
//
//  Created by Charles Trickey on 2019-09-09.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}
