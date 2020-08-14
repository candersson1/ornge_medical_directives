//
//  DrugCalculatorViewController.swift
//  OntarioMedic
//
//  Created by Charles Trickey on 2019-07-29.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import UIKit

class DrugCalculatorViewController: UIViewController
{
    @IBOutlet weak var titleLabel: UILabel!
    var drugTables : [DrugTable] = []

    @IBOutlet weak var outputStack: UIStackView!
    
    @IBOutlet weak var disclaimerLabel: UILabel!
    
    var age = 18
    var weight = 80
    
    var diluentVolume : Double = 1
    var concentration : Double = 1
    
    var doseLabels : [UILabel] = []
    var volumeLabels : [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        disclaimerLabel.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        titleLabel.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        
        /*for drugTable in drugTables
        {
            let drugMixingTable = MixingCalculatorView()
            drugMixingTable.drugNameLabel.text = drugTable.name
            drugMixingTable.concentration = drugTable.concentration
            drugMixingTable.min_range = drugTable.min_dose_range
            drugMixingTable.max_range = drugTable.max_dose_range
            drugMixingTable.max_dose = drugTable.max_dose
            drugMixingTable.inc = drugTable.doseIncrement
            
            drugMixingTable.doseWeightBased = drugTable.weight_based
            drugMixingTable.doseInfusionBased = drugTable.infusion_based
            drugMixingTable.doseWeightUnit = drugTable.unit_weight
            drugMixingTable.doseTimeUnit = drugTable.unit_time
            
            drugMixingTable.doseLabel.text = "Dose: " + drugTable.dosing_label
            drugMixingTable.concentrationLabel.text = "Concentration: " + drugTable.concentration_label//"16 mcg/ml"
            if(drugTable.diluent_label != "") {
                drugMixingTable.diluentLabel.text = "Diluent: " + drugTable.diluent_label//"D5W or NS"
            }
            if(drugTable.mixing_label != "") {
                drugMixingTable.mixingLabel.text = "Mixing: " + drugTable.mixing_label
            }
            drugMixingTable.volumeDeliveryLabel.text = drugTable.delivery_label
            drugMixingTable.volumeMultiplier = drugTable.delivery_multiplier
            
            drugMixingTable.setupFields()
            outputStack.addArrangedSubview(drugMixingTable)
            drugMixingTable.updateDoseFields()
            let spacer = UILabel()
            spacer.textColor = UIColor.white
            spacer.text = " "
            outputStack.addArrangedSubview(spacer)
        }*/
    }
}
