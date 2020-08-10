//
//  CheckBoxButton.swift
//  Medic Reference
//
//  Created by Charles Trickey on 2019-11-09.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

protocol CheckBoxButtonDelegate {
    func checkBoxChanged(checkBoxButton : CheckBoxButton)
}

class CheckBoxButton : UIButton
{
    var selectionIndex : Int = 0 {
        didSet {
            updateButtonImage()
        }
    }
    
    var delegate : CheckBoxButtonDelegate?
    
    @objc func pressed()
    {
        if(selectionIndex < 2) {
            selectionIndex += 1
        } else {
            selectionIndex = 0
        }
        
        updateButtonImage()
        
        if(delegate != nil) {
            delegate?.checkBoxChanged(checkBoxButton: self)
        }
    }
    
    func updateButtonImage() {
        switch selectionIndex {
        case 0:
            setImage(UIImage(systemName: "square"), for: .normal)
            tintColor = .label
            break
        case 1:
            setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            tintColor = .systemGreen
            break
        case 2:
            setImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
            tintColor = .systemRed
            break
        default:
            setImage(UIImage(systemName: "square"), for: .normal)
            tintColor = .label
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(pressed), for: .touchUpInside)
        setTitle("", for: .normal)
        
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(pressed), for: .touchUpInside)
        setTitle("", for: .normal)
        
        initSubviews()
    }
    
    func initSubviews()
    {
        
        /*NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: 25),
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 25)
        ])*/
        
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.lineBreakMode = .byWordWrapping
        setImage(UIImage(systemName: "square"), for: .normal)
        tintColor = .black
    }
}
