//
//  VentToo.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-14.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

class VentToolViewController : UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    var heightInInches : Int = 72
    var weightInkg : Int = 100
    
    var heightPicker = UIPickerView()
    var weightPicker = UIPickerView()
    
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: Input outlets
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var isInches: UISwitch!
    @IBOutlet weak var isFemale: UISwitch!
    
    //MARK: Output outlets
    @IBOutlet weak var idealBodyWeightTextField: UITextField!
    @IBOutlet weak var VIIIccPerKgOutlet: UITextField!
    @IBOutlet weak var VIIccPerKgOutlet: UITextField!
    @IBOutlet weak var VIccPerKgOutlet: UITextField!
    @IBOutlet weak var VccPerKgOutlet: UITextField!
    @IBOutlet weak var IVccPerKgOutlet: UITextField!
    
    
    @IBAction func heightToggleAction(_ sender: Any) {
        heightPicker.reloadAllComponents()
        if(isInches.isOn == false)
        {
            heightPicker.selectRow(Int(Float(heightInInches) * 2.54), inComponent: 0, animated: false)
            heightTextField.text = "\(Int(Float(heightInInches) * 2.54)) cm"
        } else {
            heightPicker.selectRow(heightInInches - 48, inComponent: 0, animated: false)
            heightTextField.text = "\(heightInInches) in."
        }
    }
    
    
    
    @IBAction func genderToggleAction(_ sender: Any) {
        recalculateTextFields()
    }
    
    @objc func handleTap(_ sender : Any)
    {
        heightTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let titleView = UILabel()
        titleView.text = "Mechanical Ventilation Tidal Volume Calculator"
        titleView.textColor = .white
        titleView.font = .boldSystemFont(ofSize: 17)
        titleView.lineBreakMode = .byWordWrapping
        titleView.numberOfLines = 0
        self.navigationItem.titleView = titleView
        
        heightTextField.delegate = self
        heightPicker.dataSource = self
        heightPicker.delegate = self
        weightPicker.dataSource = self
        weightPicker.delegate = self
        
        heightTextField.inputView = heightPicker
        
        heightPicker.selectRow(Int(Float(heightInInches) * 2.54), inComponent: 0, animated: false)
        weightPicker.selectRow(weightInkg - 50, inComponent: 0, animated: false)
        
        recalculateTextFields()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        scrollView.addGestureRecognizer(tap)
        scrollView.contentSize.height = 1000
    }
    
    func recalculateTextFields()
    {
        var idealBodyWeight : Float
        if(isFemale.isOn == false)
        {
            idealBodyWeight = 50 + (2.3 * Float(heightInInches - 60))
        } else {
            idealBodyWeight = 45.5 + (2.3 * Float(heightInInches - 60))
        }
        idealBodyWeightTextField.text = String(format: "%.1f kg", idealBodyWeight)
        
        VIIIccPerKgOutlet.text = String(format: "%.0f cc", idealBodyWeight * 8)
        VIIccPerKgOutlet.text = String(format: "%.0f cc", idealBodyWeight * 7)
        VIccPerKgOutlet.text = String(format: "%.0f cc", idealBodyWeight * 6)
        VccPerKgOutlet.text = String(format: "%.0f cc", idealBodyWeight * 5)
        IVccPerKgOutlet.text = String(format: "%.0f cc", idealBodyWeight * 4)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == heightPicker)
        {
            if(isInches.isOn == true)
            {
                return 48
            }
            else
            {
                return 200
            }
        }
        return 400
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
            if(isInches.isOn == false)
            {
                return "\(row) cm"
            } else {
                
                return "\(row + 48) in."
                
            }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == heightPicker)
        {
            if(isInches.isOn == false)
            {
                heightTextField.text = "\(row) cm"
                heightInInches = Int(Float(row) / 2.54)
            } else {
                heightTextField.text = "\(row + 48) in."
                heightInInches = row + 48
            }
        }
        recalculateTextFields()
    }
}
