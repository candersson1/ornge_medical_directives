//
//  DisclaimerViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2020-01-24.
//  Copyright © 2020 Charles Trickey. All rights reserved.
//

import UIKit

class DisclaimerViewController: UIViewController {

    @IBOutlet weak var acceptButtonOutlet: UIButton!
    
    @IBAction func acceptButtonAction(_ sender: Any) {
        DataManager.instance.waiverComplete = true
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acceptButtonOutlet.layer.borderColor = UIColor.black.cgColor
        acceptButtonOutlet.layer.borderWidth = 1
        acceptButtonOutlet.layer.cornerRadius = 3
        // Do any additional setup after loading the view.
    }

}
