//
//  MixingCalculator.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-16.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit


class MixingCalculatorView_L : UIView, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet var contentView: MixingCalculatorView_L!
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
