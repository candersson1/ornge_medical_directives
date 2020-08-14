//
//  SettingsViewController.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-17.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController
{
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontSizeSlider: UISlider!
    
    @IBAction func fontSliderAction(_ sender: Any) {
        let value = fontSizeSlider.value
        fontSizeSlider.value = roundf(((value + 0.5) / 0.5) * 0.5)
        DataManager.instance.fontSize = fontSizeSlider.value
        normalStyle.font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        titleStyle.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize + 3))
        boldStyle.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        italicStyle.font = UIFont.italicSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        linkStyle.font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        boldItalicStyle.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        
        updateFont()
        UserDefaults.standard.set(fontSizeSlider.value, forKey: "font_size")
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        fontSizeSlider.value = DataManager.instance.fontSize
        fontSizeLabel.text = "Font Size: \(fontSizeSlider.value)"
        updateFont()
    }
    
    func updateFont()
    {
        fontSizeLabel.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        fontSizeLabel.text = "Font Size: \(fontSizeSlider.value)"
    }
}
