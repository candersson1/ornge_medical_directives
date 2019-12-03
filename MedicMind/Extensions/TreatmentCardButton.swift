//
//  TreatmentCardButton.swift
//  OntarioMedic
//
//  Created by Charles Trickey on 2019-07-26.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

class TreatmentCardButton : UIButton
{
    var parentView : MedicalDirectiveView?
    var key : String = "nil"
    var useLabelSize : Bool = false

    override var intrinsicContentSize: CGSize {
        if(useLabelSize == true)
        {
            let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)) ?? .zero
            let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
            return desiredButtonSize
        }
        
        return super.intrinsicContentSize
    }
}
