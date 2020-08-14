//
//  MixingCalculator.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-16.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit


class MixingCalculatorView : UIView, UITextFieldDelegate
{
    @IBOutlet var contentView: MixingCalculatorView!
    var parentView : UIView?
    @IBOutlet weak var parentStackView: UIStackView!
    
    @IBOutlet weak var drugDiluentLabel: UILabel!
    @IBOutlet weak var drugAmountLabel: UILabel!
    @IBOutlet weak var drugDosingLabel: UILabel!
    @IBOutlet weak var drugConcentrationLabel: UILabel!
    
    @IBOutlet weak var weightTextField: UITextField!
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var patientWeightTitleLabel: UILabel!
    @IBOutlet weak var patientWeightUnitsLabel: UILabel!
    
    @IBOutlet weak var doseTitleLabel: UILabel!
    
    
    @IBOutlet weak var outputStackView: UIStackView!
    
    var weight : Double = DataManager.instance.lastSetWeight
    var numElements = 2
    var concentration = 1.0
    var dose_titles : [String] = []
    var dose_array : [Double] = []
    
    var doseTimeUnit = "hr"
    var doseWeightUnit = "mg"
    
    var weightBased : Bool = true
    
    var doseFieldsArray : [UILabel] = []
    var volumeFieldsArray : [UILabel] = []
    
    var font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
    var boldFont = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    @objc func tapAction()
    {
        if(weightBased) {
            weightTextField.resignFirstResponder()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        initFonts()
    }
    
    @IBOutlet weak var patientWeightStack: UIStackView!
    
    convenience init(data : DrugTable) {
        self.init(frame: CGRect.zero)
        
        titleLabel.attributedText = ("<b>\(data.name)</b>").set(style: styleGroup)
        drugDosingLabel.attributedText = data.dosing_label.set(style: styleGroup)
        drugAmountLabel.attributedText = ("<b>Drug Amount:</b> \(data.amount_label)").set(style: styleGroup)
        drugDiluentLabel.attributedText = ("<b>Diluent:</b> \(data.diluent_label)").set(style: styleGroup)
        drugConcentrationLabel.attributedText = ("<center><b>Concentration:</b>\n\(data.concentration_label)</center>").set(style: styleGroup)
        
        patientWeightTitleLabel.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        patientWeightUnitsLabel.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        
        weightBased = data.weight_based
        dose_titles = data.dose_titles
        dose_array = data.dose_array
        doseTimeUnit = data.unit_time
        doseWeightUnit = data.unit_weight
        
        concentration = data.concentration
        numElements = dose_array.count
        
        weightTextField.text = "\(weight)"
        
        if(weightBased) {
            buildWeightBasedStacks()
        } else {
            buildNonWeightBasedStacks()
        }
        
        outputStackView.addBackground(color: .black, outlineColor: .black)
        updateVolumeFields()
    }
    
    func initFonts() {
        
        titleLabel.font = boldFont
        drugDiluentLabel.font = font
        drugAmountLabel.font = font
        drugDosingLabel.font = font
        
        weightTextField.font = font
        doseTitleLabel.font = boldFont
        drugConcentrationLabel.layer.borderWidth = 0.5
    }
    
    func setTapGestureRecognizer()
    {
        if(parentView != nil)
        {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction))
            parentView!.addGestureRecognizer(tap)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let value = Double(textField.text!)
        if(value != nil) {
            weight = value!
            DataManager.instance.lastSetWeight = weight
            updateVolumeFields()
        }
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "MixingCalculatorView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.frame = bounds
        addSubview(contentView)
 
        weightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    func buildWeightBasedStacks() {
        var numElementsPerRow = 8
        if DataManager.instance.fontSize >= 14 && DataManager.instance.fontSize < 16 {
            numElementsPerRow = 6
        } else if DataManager.instance.fontSize >= 16 {
            numElementsPerRow = 5
        }
        let numRows : Int = (numElements / numElementsPerRow) + 1
        
        var elementCounter = 0
        
        for _ in 0 ..< numRows {
            let hDoseStack = UIStackView()
            hDoseStack.axis = .horizontal
            hDoseStack.translatesAutoresizingMaskIntoConstraints = false
            hDoseStack.addBackground(color: .black)
            outputStackView.addArrangedSubview(hDoseStack)
            
            let doseView = UIView()
            doseView.layer.borderWidth = 0.5
            doseView.layer.borderColor = UIColor.white.cgColor
            let doseUnitsLabel = UILabel()
            doseUnitsLabel.font = boldFont
            doseUnitsLabel.textColor = .white
            if(doseTimeUnit == "") {
                doseUnitsLabel.text = "Dose(\(doseWeightUnit)/kg)"
            } else {
                doseUnitsLabel.text = "Dose(\(doseWeightUnit)/kg/\(doseTimeUnit))"
            }
            
            doseView.embedInsideSafeAreaWithPadding(doseUnitsLabel, padding: UIEdgeInsets(top: 2, left: 2, bottom: -2, right: -2))
            hDoseStack.addArrangedSubview(doseView)
            doseView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            doseUnitsLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            let hVolumeStack = UIStackView()
            hVolumeStack.axis = .horizontal
            hVolumeStack.translatesAutoresizingMaskIntoConstraints = false
            hVolumeStack.addBackground(color: .white)
            outputStackView.addArrangedSubview(hVolumeStack)
            
            let volumeView = UIView()
            volumeView.layer.borderWidth = 0.5
            volumeView.layer.borderColor = UIColor.black.cgColor
            let doseVolumeLabel = UILabel()
            doseVolumeLabel.font = boldFont
            doseVolumeLabel.textColor = .black
            if(doseTimeUnit == "") {
                doseVolumeLabel.text = "ml"
            } else {
                doseVolumeLabel.text = "ml/hr"
            }
            volumeView.embedInsideSafeAreaWithPadding(doseVolumeLabel, padding: UIEdgeInsets(top: 2, left: 2, bottom: -2, right: -2))
            hVolumeStack.addArrangedSubview(volumeView)
            volumeView.widthAnchor.constraint(equalTo: doseView.widthAnchor)
            .isActive = true
            volumeView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            let subHDoseStack = UIStackView()
            subHDoseStack.axis = .horizontal
            subHDoseStack.distribution = .fillEqually
            subHDoseStack.translatesAutoresizingMaskIntoConstraints = false
            subHDoseStack.addBackground(color: .black)
            hDoseStack.addArrangedSubview(subHDoseStack)
            
            let subHVolumeStack = UIStackView()
            subHVolumeStack.axis = .horizontal
            subHVolumeStack.distribution = .fillEqually
            subHVolumeStack.translatesAutoresizingMaskIntoConstraints = false
            subHVolumeStack.addBackground(color: .white)
            hVolumeStack.addArrangedSubview(subHVolumeStack)
            
            for _ in 0 ..< numElementsPerRow {
                if(elementCounter >= numElements) {
                    return
                }
                var view = UIView()
                view.layer.borderWidth = 0.5
                view.layer.borderColor = UIColor.white.cgColor
                var label = UILabel()
                label.font = font
                label.textAlignment = .center
                label.textColor = .white
                label.text = "\((dose_array[elementCounter]).rounded(toPlaces: 2))"
                view.embedInsideSafeAreaWithPadding(label, padding: UIEdgeInsets(top: 2, left: 2, bottom: -2, right: -2))
                subHDoseStack.addArrangedSubview(view)
                
                view = UIView()
                view.layer.borderWidth = 0.5
                view.layer.borderColor = UIColor.black.cgColor
                label = UILabel()
                label.font = font
                label.textAlignment = .center
                label.textColor = .black
                view.embedInsideSafeAreaWithPadding(label, padding: UIEdgeInsets(top: 2, left: 2, bottom: -2, right: -2))
                subHVolumeStack.addArrangedSubview(view)
                volumeFieldsArray.append(label)
                
                elementCounter += 1
            }
        }
    }
    
    func buildNonWeightBasedStacks() {
        
        patientWeightStack.removeFromSuperview()
        
        let hDoseStack = UIStackView()
        hDoseStack.axis = .horizontal
        hDoseStack.translatesAutoresizingMaskIntoConstraints = false
        hDoseStack.addBackground(color: .black)
        hDoseStack.distribution = .fillEqually
        outputStackView.addArrangedSubview(hDoseStack)
        
        var label = UILabel()
        label.font = boldFont
        label.textAlignment = .center
        label.textColor = .white
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 0.5
        if(doseTimeUnit == "") {
            label.text = "Dose(\(doseWeightUnit))"
        } else {
            label.text = "Dose(\(doseWeightUnit)/\(doseTimeUnit))"
        }
        hDoseStack.addArrangedSubview(label)
        
        label = UILabel()
        label.font = boldFont
        label.textAlignment = .center
        label.textColor = .white
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 0.5
        if(doseTimeUnit == "") {
            label.text = "ml"
        } else {
            label.text = "ml/hr"
        }
        
        hDoseStack.addArrangedSubview(label)
        var greyCell = false
        for dose in dose_array {
            let hDoseSubStack = UIStackView()
            hDoseSubStack.axis = .horizontal
            hDoseSubStack.translatesAutoresizingMaskIntoConstraints = false
            if(greyCell)
            {
                hDoseSubStack.addBackground(color: .systemGray4)
            } else {
                hDoseSubStack.addBackground(color: .white)
            }
            greyCell = !greyCell
            hDoseSubStack.distribution = .fillEqually
            outputStackView.addArrangedSubview(hDoseSubStack)
            
            var label = UILabel()
            label.font = font
            label.textAlignment = .center
            label.textColor = .black
            label.text = "\(dose.rounded(toPlaces: 2))"
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 0.5
            hDoseSubStack.addArrangedSubview(label)
            
            label = UILabel()
            label.font = font
            label.textAlignment = .center
            label.textColor = .black
            label.layer.borderColor = UIColor.black.cgColor
            label.layer.borderWidth = 0.5
            hDoseSubStack.addArrangedSubview(label)
            volumeFieldsArray.append(label)
        }
    }
    
    func updateVolumeFields() {
        for i in 0 ..< volumeFieldsArray.count {
            var volume = dose_array[i]
            if(weightBased) {
                volume *= weight
            }
            volume /= concentration
            if(doseTimeUnit == "min") {
                volume *= 60
            }
            volumeFieldsArray[i].text = "\(volume.rounded(toPlaces: 1))"
        }
    }
}

