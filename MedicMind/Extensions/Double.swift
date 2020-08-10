//
//  Double.swift
//  Ornge
//
//  Created by Charles Trickey on 2019-12-13.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
