//
//  ViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-08-31.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    @objc private func popToPrevious() {
        // our custom stuff
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupNavigationBar() {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "Ornge Banner"), for: .normal)
        button.heightAnchor.constraint(equalTo: button.widthAnchor, multiplier: 640/1536).isActive = true
        button.isUserInteractionEnabled = false

        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItems = [barButton]
        
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
