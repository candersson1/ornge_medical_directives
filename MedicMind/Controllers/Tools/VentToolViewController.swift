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
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var isInches: UISwitch!
    @IBOutlet weak var isLbs: UISwitch!
    @IBOutlet weak var isFemale: UISwitch!
    
    //MARK: Output outlets
    @IBOutlet weak var idealBodyWeightTextField: UITextField!
    @IBOutlet weak var VIIIccPerKgOutlet: UITextField!
    @IBOutlet weak var VIIccPerKgOutlet: UITextField!
    @IBOutlet weak var VIccPerKgOutlet: UITextField!
    @IBOutlet weak var VccPerKgOutlet: UITextField!
    @IBOutlet weak var IVccPerKgOutlet: UITextField!
    
    @IBOutlet weak var ketamineBolusOutlet: UITextField!
    @IBOutlet weak var ketamineInfusionOutlet: UITextField!
    @IBOutlet weak var fentanylBolusOutlet: UITextField!
    @IBOutlet weak var fentanylInfusionOutlet: UITextField!
    @IBOutlet weak var versedBolusOutlet: UITextField!
    @IBOutlet weak var versedInfusionOutlet: UITextField!
    @IBOutlet weak var propofolBolusOutlet: UITextField!
    @IBOutlet weak var propofolInfusionOutlet : UITextField!
    
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
    
    @IBAction func weightToggleAction(_ sender: Any) {
        weightPicker.reloadAllComponents()
        if(isLbs.isOn == false)
        {
            weightPicker.selectRow(weightInkg - 50, inComponent: 0, animated: false)
            weightTextField.text = "\(weightInkg) kg"
        } else {
            weightPicker.selectRow(Int(Float(weightInkg) * 2.2), inComponent: 0, animated: false)
            weightTextField.text = "\(Int(Float(weightInkg) * 2.2)) lbs"
        }
    }
    
    @IBAction func genderToggleAction(_ sender: Any) {
        recalculateTextFields()
    }
    
    @objc func handleTap(_ sender : Any)
    {
        heightTextField.resignFirstResponder()
        weightTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        heightTextField.delegate = self
        weightTextField.delegate = self
        heightPicker.dataSource = self
        heightPicker.delegate = self
        weightPicker.dataSource = self
        weightPicker.delegate = self
        
        heightTextField.inputView = heightPicker
        weightTextField.inputView = weightPicker
        
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
        
        fentanylBolusOutlet.text = "50-100 mcg IVP q 5 minutes"
        fentanylInfusionOutlet.text = String(format:"%.0f-%.0f mg/hr", (Float(weightInkg)), (Float(weightInkg)*3))
        
        versedBolusOutlet.text = "1-2 mg IVP prn q 5 minutes"
        versedInfusionOutlet.text = String(format:"%.0f-%.0f mg/hr", (Float(weightInkg)*0.05), (Float(weightInkg)*0.15))
        
        ketamineBolusOutlet.text = String(format:"%.0f-%.0f mg IVP", (Float(weightInkg)), (Float(weightInkg)*2))
        ketamineInfusionOutlet.text = String(format:"%.0f-%.0f mg/hr", (Float(weightInkg)*0.3), (Float(weightInkg)*2))
        
        propofolBolusOutlet.text = "10-20 mg IVP q 5 minutes"
        propofolInfusionOutlet.text = String(format:"0-%.0f mcg/min", (Float(weightInkg)), (Float(weightInkg)*80))
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
        if(pickerView == weightPicker)
        {
            if(isLbs.isOn == false)
            {
                return "\(row + 50) kg"
            }else{
                return "\(row) lbs"
            }
        }
        else
        {
            if(isInches.isOn == false)
            {
                return "\(row) cm"
            } else {
                
                return "\(row + 48) in."
                
            }
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
        else if(pickerView == weightPicker)
        {
            weightInkg = row
            if(isLbs.isOn == false)
            {
                weightInkg = row + 50
                weightTextField.text = "\(row + 50) kg"
            } else {
                weightInkg = Int(Float(row) / 2.2)
                weightTextField.text = "\(row) lbs"
            }
        }
        recalculateTextFields()
    }
}
