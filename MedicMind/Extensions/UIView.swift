//
//  UIView.swift
//  Medic Reference
//
//  Created by Charles Trickey on 2019-11-17.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}

extension UIView {
  func embedInsideSafeArea(_ subview: UIView) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
    subview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor)
      .isActive = true
    subview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
      .isActive = true
    subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
      .isActive = true
    subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
      .isActive = true
  }
    
    func embedInsideSafeAreaWithPadding(_ subview: UIView, padding : UIEdgeInsets) {
      addSubview(subview)
      subview.translatesAutoresizingMaskIntoConstraints = false
        subview.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding.left)
        .isActive = true
        subview.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: padding.right)
        .isActive = true
        subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding.top)
        .isActive = true
        subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: padding.bottom)
        .isActive = true
    }
}
