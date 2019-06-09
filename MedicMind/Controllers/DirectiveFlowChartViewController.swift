//
//  DirectiveFlowChartViewController.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-05-18.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

class DirectiveFlowChartViewController : UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
        
        if let image = UIImage(named: "bronchoconstriction flow chart")
        {
            imageView.image = image
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

}
