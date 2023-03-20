//
//  ClosedIntervalExtension.swift
//  OntarioMedic
//
//  Created by Charles Trickey on 2019-07-18.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation

extension ClosedRange {
    func clamp(_ value : Bound) -> Bound {
        return self.lowerBound > value ? self.lowerBound
            : self.upperBound < value ? self.upperBound
            : value
    }
}
