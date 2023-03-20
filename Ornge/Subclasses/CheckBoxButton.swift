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
        var labelColor : UIColor
        if #available(iOS 13.0, *) {
            labelColor = UIColor.label
        } else {
            labelColor = UIColor.black
        }
        
        switch selectionIndex {
        case 0:
            if #available(iOS 13.0, *) {
                setImage(UIImage(systemName: "square"), for: .normal)
            } else {
                let image = UIImage(named: "square")
                setBackgroundImage(image, for: .normal)
                //setImage(UIImage(named: "square.png"), for: .normal)
            }
            tintColor = labelColor
            break
        case 1:
            if #available(iOS 13.0, *) {
                setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            } else {
                setBackgroundImage(UIImage(named: "checkmark-square-fill"), for: .normal)
            }
            tintColor = .systemGreen
            break
        case 2:
            if #available(iOS 13.0, *) {
                setImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
            } else {
                setBackgroundImage(UIImage(named: "xmark-square-fill"), for: .normal)
            }
            tintColor = .systemRed
            break
        default:
            if #available(iOS 13.0, *) {
                setImage(UIImage(systemName: "square"), for: .normal)
            } else {
                setBackgroundImage(UIImage(named: "square"), for: .normal)
            }
            tintColor = labelColor
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
        if #available(iOS 13.0, *) {
            setImage(UIImage(systemName: "square"), for: .normal)
        } else {
            let image = UIImage(named: "square")
            setBackgroundImage(image, for: .normal)
        }
        tintColor = .black
    }
}
