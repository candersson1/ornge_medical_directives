//
//  MixingCalculator.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-16.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

/*import Foundation
import UIKit


class MixingCalculatorView : UIView, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet var contentView: MixingCalculatorView!
    var parentView : UIView?
    
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var unitsStackView: UIStackView!
    @IBOutlet weak var doseStackView: UIStackView!
    @IBOutlet weak var tableStackView: UIStackView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var patientWeightLabel: UILabel!
    
    let weightPicker = UIPickerView()
    var weight : Double = 80
    var numElements = 0
    var numLabels = 0
    var oldMin = 0.0
    var min_range = 0.25
    var max_range = 1.5
    var max_dose = -1.0
    var inc = 0.25
    
    var doseWeightUnit = "mg"
    var doseTimeUnit = "hr"
    var doseWeightBased : Bool = true
    var doseInfusionBased : Bool = true
    
    @IBOutlet weak var volumeDeliveryLabel: UILabel!
    
    @IBOutlet weak var doseLabel: UILabel!
    @IBOutlet weak var concentrationLabel: UILabel!
    @IBOutlet weak var diluentLabel: UILabel!
    @IBOutlet weak var mixingLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var calculatedDoseLabel: UILabel!
    
    var concentration = 1.0
    var volumeMultiplier = 1.0

    var elementsTapped = false
    
    var doseFieldsArray : [UILabel] = []
    var calculatedDoseFieldsArray : [UILabel] = []
    var volumeFieldsArray : [UILabel] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    @objc func touchAction()
    {
        if(numElements > 6 && elementsTapped == false)
        {
                oldMin = min_range
                min_range = min_range + (6 * inc)

                elementsTapped = true
                
        } else {
                min_range = oldMin
                elementsTapped = false
        }
        weightTextField.resignFirstResponder()
        updateDoseFields()
    }
    
    @objc func tapAction()
    {
        weightTextField.resignFirstResponder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchAction))
        contentView.addGestureRecognizer(tap)
        let font = UIFont(name: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize))
        let boldFont = UIFont(name: DataManager.instance.boldFontName, size: CGFloat(DataManager.instance.fontSize))
        drugNameLabel.font = boldFont
        unitsLabel.font = font
        weightTextField.font = font
        diluentLabel.font = font
        concentrationLabel.font = font
        mixingLabel.font = font
        volumeDeliveryLabel.font = font
        doseLabel.font = font
        calculatedDoseLabel.font = font
        patientWeightLabel.font = font
    }
    
    func setTapGestureRecognizer()
    {
        if(parentView != nil)
        {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
            parentView!.addGestureRecognizer(tap)
        }
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "MixingCalculatorView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.frame = bounds
        addSubview(contentView)
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        weightTextField.inputView = weightPicker
        weightPicker.selectRow(16, inComponent: 0, animated: false)
    }
    
    func setupFields()
    {
        if(doseWeightBased == true)
        {
            if( doseInfusionBased == true)
            {
                unitsLabel.text = "\(doseWeightUnit)/kg/\(doseTimeUnit)"
                calculatedDoseLabel.text = "\(doseWeightUnit)/\(doseTimeUnit)"
            }
            else
            {
                unitsLabel.text = "\(doseWeightUnit)/kg"
                calculatedDoseLabel.text = "\(doseWeightUnit)"
            }
        } else {
            if( doseInfusionBased == true)
            {
                unitsLabel.text = "\(doseWeightUnit)/\(doseTimeUnit)"
                
            }
            else {
                unitsLabel.text = "\(doseWeightUnit)"
            }
        }
        
        let font = UIFont(name: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize))
        

        if(doseWeightBased == false)
        {
            weightTextField.isEnabled = false
            weightTextField.text = "-"
            weightTextField.textColor = UIColor.lightGray
            weightTextField.backgroundColor = UIColor.white
        }
        
        numElements = (Int((max_range - min_range) / inc)) + 1
        if(max_range == min_range)
        {
            numElements = 1
        }
        oldMin = min_range
        
        var label : UILabel
        label = UILabel()
        label.font = font
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        let str = "\(min_range)"
        label.text = str
        unitsStackView.addArrangedSubview(label)
        doseFieldsArray.append(label)

        label = UILabel()
        label.font = font
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        label.text = str
        doseStackView.addArrangedSubview(label)
        calculatedDoseFieldsArray.append(label)
        
        var prevDoseLabel = label
        var prevCalcDoseLabel = label

        
        numLabels = 4
        if( numElements < 5)
        {
            numLabels = numElements-1
        }
        if( numLabels > 0)
        {
            for _ in 1 ... numLabels
            {
                label = UILabel()
                label.font = font
                label.backgroundColor = .black
                label.textColor = .white
                label.textAlignment = .center
                
                unitsStackView.addArrangedSubview(label)
                NSLayoutConstraint.activate([
                    label.widthAnchor.constraint(equalTo: prevDoseLabel.widthAnchor)
                    ])
                doseFieldsArray.append(label)
                
                prevDoseLabel = label

                
                label = UILabel()
                label.font = font
                label.backgroundColor = .black
                label.textColor = .white
                label.textAlignment = .center
                
                doseStackView.addArrangedSubview(label)
                NSLayoutConstraint.activate([ label.widthAnchor.constraint(equalTo: prevCalcDoseLabel.widthAnchor)])
                calculatedDoseFieldsArray.append(label)
                prevCalcDoseLabel = label
            }
        }
        for _ in 0 ... numLabels
        {
            label = UILabel()
            label.font = font
            label.backgroundColor = .white
            label.textColor = .black
            label.textAlignment = .center
            
            
            tableStackView.addArrangedSubview(label)
            NSLayoutConstraint.activate([label.widthAnchor.constraint(equalTo: prevDoseLabel.widthAnchor)])
            volumeFieldsArray.append(label)
            prevDoseLabel = label
        }
        
        updateDoseFields()
    }
    
    func updateDoseFields() {
        for i in 0 ... numLabels {
            
            let dose = Double(min_range + (inc * Double(i)))
            var doseDelivered = dose
            var maxDoseFlag = false
            
            var str = "\((dose * 100).rounded()/100)"
            doseFieldsArray[i].text = str
            var mlPerHr = 0.0
            
            if(doseWeightBased == true) {
                doseDelivered = (dose * weight)
            } else {
                doseDelivered = (dose)
            }
            
            if(doseDelivered >= max_dose && max_dose > 0.0) {
                maxDoseFlag = true
                doseDelivered = max_dose
            }
            
            calculatedDoseFieldsArray[i].text = "\(doseDelivered)"
            
            doseDelivered = doseDelivered / concentration
            
            if(doseInfusionBased == true) {
                mlPerHr = doseDelivered * volumeMultiplier
            } else {
                mlPerHr = doseDelivered
            }
            if(maxDoseFlag == true) {
                volumeFieldsArray[i].textColor = UIColor.red
                volumeFieldsArray[i].text = "MAX \(mlPerHr)"
            }
            else {
                str = "\((mlPerHr * 100).rounded()/100)"
                volumeFieldsArray[i].textColor = UIColor.black
                volumeFieldsArray[i].text = str
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\((row * 5) + 5) kg"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weightTextField.text = "\((row * 5) + 5) kg  ▿"
        weight = Double((row * 5) + 5)
        updateDoseFields()
    }
}*/

//
//  MixingCalculator.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-16.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit


class MixingCalculatorView : UIView, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet var contentView: MixingCalculatorView!
    var parentView : UIView?
    
    @IBOutlet weak var drugNameLabel: UILabel!
    @IBOutlet weak var drugDiluentLabel: UILabel!
    @IBOutlet weak var drugAmountLabel: UILabel!
    @IBOutlet weak var drugDosingLabel: UILabel!
    @IBOutlet weak var unitsStackView: UIStackView!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var tableStackView: UIStackView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var drugConcentrationLabel: UILabel!
    
    let weightPicker = UIPickerView()
    var weight : Double = 80
    var numElements = 0
    var concentration = 1.0
    var oldMin = 0.0
    var min = 0.25
    var max = 1.5
    var inc = 0.25
    var doseTimeUnit = "hr"
    
    var elementsTapped = false
    
    var weightBased : Bool = true
    
    var doseFieldsArray : [UILabel] = []
    var volumeFieldsArray : [UILabel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    @objc func touchAction()
    {
        if(Int((max - min)/inc) > 6 && elementsTapped == false)
        {
            
                oldMin = min
                min = min + (6 * inc)

                elementsTapped = true
                
        } else {
                min = oldMin
                elementsTapped = false
            
        }
        weightTextField.resignFirstResponder()
        updateDoseFields()
    }
    
    @objc func tapAction()
    {
        weightTextField.resignFirstResponder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchAction))
        contentView.addGestureRecognizer(tap)
        let font = UIFont(name: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize))
        drugNameLabel.font = font
        drugDiluentLabel.font = font
        drugAmountLabel.font = font
        drugDosingLabel.font = font
        unitsLabel.font = font
        weightTextField.font = font
        drugConcentrationLabel.font = font
    }
    
    func setTapGestureRecognizer()
    {
        if(parentView != nil)
        {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
            parentView!.addGestureRecognizer(tap)
        }
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "MixingCalculatorView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.frame = bounds
        addSubview(contentView)
        
        numElements = Int((max - min) / inc)
        
        let font = UIFont(name: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize))
        
        var label : UILabel
        label = UILabel()
        label.font = font
        label.backgroundColor = .black
        label.textColor = .white
        label.textAlignment = .center
        let str = "\(min)"
        label.text = str
        unitsStackView.addArrangedSubview(label)
        doseFieldsArray.append(label)

        var prevLabel = label
        
        for i in 1 ... numElements
        {
            label = UILabel()
            label.font = font
            label.backgroundColor = .black
            label.textColor = .white
            label.textAlignment = .center
            let str = "\(min + (inc * Double(i)))"
            label.text = str
            
            unitsStackView.addArrangedSubview(label)
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalTo: prevLabel.widthAnchor)
                ])
            doseFieldsArray.append(label)
            prevLabel = label
        }
        
        for _ in 0 ... numElements
        {
            label = UILabel()
            label.font = font
            label.backgroundColor = .white
            label.textColor = .black
            label.textAlignment = .center
            
            
            tableStackView.addArrangedSubview(label)
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalTo: prevLabel.widthAnchor)
                ])
            volumeFieldsArray.append(label)
            prevLabel = label
        }
        weightPicker.delegate = self
        weightPicker.dataSource = self
        weightTextField.inputView = weightPicker
        weightPicker.selectRow(8, inComponent: 0, animated: false)
        
        updateDoseFields()
    }
    
    func updateDoseFields()
    {
        for i in 0 ... numElements
        {
            let dose = min + (inc * Double(i))
            var str = "\(dose)"
            doseFieldsArray[i].text = str
            var mlPerHr = 0.0
            
            if(weightBased == true)
            {
                mlPerHr = (dose * weight) / concentration
            }
            else
            {
                 mlPerHr = (dose) / concentration
            }
            if(doseTimeUnit == "min")
            {
                mlPerHr = mlPerHr * 60
            }
            
            str = "\(mlPerHr)"
            volumeFieldsArray[i].text = str
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 13
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\((row * 5) + 40) kg"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        weightTextField.text = "\((row * 5) + 40) kg  ▿"
        weight = Double((row * 5) + 40)
        updateDoseFields()
    }
}

