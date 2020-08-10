//
//  YSiteCompatibilityViewController.swift
//  Ornge
//
//  Created by Charles Trickey on 2019-10-20.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import UIKit

class YSiteCompatibilityViewController: UIViewController {
    
    var initialField : Drug {
        set {
            drug0 = newValue
            //checkTextFields()
        }
        get {
            return drug0!
        }
    }
    
    @IBOutlet weak var textField0: UITextField!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    
    let textPicker0 = UIPickerView()
    let textPicker1 = UIPickerView()
    let textPicker2 = UIPickerView()
    let textPicker3 = UIPickerView()
    
    var drug0 : Drug?
    var drug1 : Drug?
    var drug2 : Drug?
    var drug3 : Drug?
    
    var drugArray : [Drug] = []

    @IBOutlet weak var resultsLabel: UILabel!
    
    @objc func tappedViewAction()
    {
        if let firstResponder = view.window?.firstResponder {
            firstResponder.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //build the appropriate drug data
        for drug in DataManager.instance.drugData
        {
            if(drug.y_site.count > 0)
            {
                drugArray.append(drug)
            }
        }

        textField0.inputView = textPicker0
        textField0.delegate = self
        
        textPicker0.dataSource = self
        textPicker0.delegate = self
        
        textField1.inputView = textPicker1
        textField1.delegate = self
        
        textPicker1.dataSource = self
        textPicker1.delegate = self
        
        textField2.inputView = textPicker2
        textField2.delegate = self
        
        textPicker2.dataSource = self
        textPicker2.delegate = self
        
        textField3.inputView = textPicker3
        textField3.delegate = self
        
        textPicker3.dataSource = self
        textPicker3.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedViewAction))
        view.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
        
        if(drug0 != nil) {
            textField0.text = drug0?.name
        }
    }
    
    func checkTextFields()
    {
        resultsLabel.text = ""
        if(drug0 != nil)
        {
            if(drug1 != nil)
            {
                if(drug0?.y_site[drug1!.key] == false || drug1?.y_site[drug0!.key] == false)
                {
                    resultsLabel.text = resultsLabel.text! + "\(drug0!.name) is incompatible with \(drug1!.name)\n"
                    resultsLabel.textColor = UIColor.red
                }
            }
            if(drug2 != nil)
            {
                if(drug0?.y_site[drug2!.key] == false || drug2?.y_site[drug0!.key] == false)
                {
                    resultsLabel.text = resultsLabel.text! + "\(drug0!.name) is incompatible with \(drug2!.name)\n"
                    resultsLabel.textColor = UIColor.red
                }
            }
            if(drug3 != nil)
            {
                if(drug0?.y_site[drug3!.key] == false || drug3?.y_site[drug0!.key] == false)
                {
                    resultsLabel.text = resultsLabel.text! + "\(drug0!.name) is incompatible with \(drug3!.name)\n"
                    resultsLabel.textColor = UIColor.red
                }
            }
        }
        if( drug1 != nil)
        {
            
            if(drug2 != nil)
            {
                if(drug1?.y_site[drug2!.key] == false || drug2?.y_site[drug1!.key] == false)
                {
                    resultsLabel.text = resultsLabel.text! + "\(drug1!.name) is incompatible with \(drug2!.name)\n"
                    resultsLabel.textColor = UIColor.red
                }
            }
            if(drug3 != nil)
            {
                if(drug1?.y_site[drug3!.key] == false || drug3?.y_site[drug1!.key] == false)
                {
                    resultsLabel.text = resultsLabel.text! + "\(drug1!.name) is incompatible with \(drug3!.name)\n"
                    resultsLabel.textColor = UIColor.red
                }
            }
        }
        if( drug2 != nil)
        {
            
            if(drug3 != nil)
            {
                if(drug2?.y_site[drug3!.key] == false || drug3?.y_site[drug2!.key] == false)
                {
                    resultsLabel.text = resultsLabel.text! + "\(drug2!.name) is incompatible with \(drug3!.name)\n"
                    resultsLabel.textColor = UIColor.red
                }
            }
        }
        
        if( resultsLabel.text == "")
        {
            resultsLabel.text = "No compatibility issues found."
            resultsLabel.textColor = UIColor.label
        }
    }
}

//MARK: UIPickerViewDataSource, UIPickerViewDelegate
extension YSiteCompatibilityViewController : UIPickerViewDataSource, UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return drugArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drugArray[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == textPicker0)
        {
            drug0 = drugArray[row]
            textField0.text = drugArray[row].name
        }
        else if(pickerView == textPicker1)
        {
            drug1 = drugArray[row]
            textField1.text = drugArray[row].name
        }
        else if(pickerView == textPicker2)
        {
            drug2 = drugArray[row]
            textField2.text = drugArray[row].name
        }
        else if(pickerView == textPicker3)
        {
            drug3 = drugArray[row]
            textField3.text = drugArray[row].name
        }
        
        checkTextFields()
    }
}

//MARK: UITextFieldDelegate
extension YSiteCompatibilityViewController : UITextFieldDelegate
{
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if( textField == textField0)
        {
            drug0 = nil
        }
        else if( textField == textField1)
        {
            drug1 = nil
        }
        else if( textField == textField2)
        {
            drug2 = nil
        }
        else if( textField == textField3)
        {
            drug3 = nil
        }
        
        checkTextFields()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
