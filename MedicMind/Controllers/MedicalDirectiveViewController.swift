//
//  MedicalDirectiveViewController.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-05-13.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit

let pcpColor = UIColor(hex: "#918b75ff")
let acpColor = UIColor(hex: "#7fc5ffff")
let ccpColor = UIColor(hex: "#cdbce0ff")
let pccpColor = UIColor(hex: "#ff96ddff")
let noPatchColor = UIColor(hex: "#50ba5aff")
let patchAfterColor = UIColor(hex: "#fff319ff")
let patchFirstColor = UIColor(hex: "#ff522bff")

class MedicalDirectiveViewController : UIViewController
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    var currentDirective : MedicalDirective?
    
    @objc func flowchartTapped()
    {
        print("Trying to load the flowchart view")
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: "DirectiveFlowChartViewController") as! DirectiveFlowChartViewController
        
        //viewController.drugData = DataManager.instance.drugByKey(key: drugKey)
        navController!.pushViewController(viewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Flowchart", style: .plain, target: self, action: #selector(flowchartTapped))
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Attaching the content's edges to the scroll view's edges
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            // Satisfying size constraints
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
        
        let indicationsTitleLabel = UILabel()
        indicationsTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        indicationsTitleLabel.text = "Indications:"
        indicationsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(indicationsTitleLabel)
        
        let indicationsLabel = UILabel()
        indicationsLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        indicationsLabel.numberOfLines = 0
        indicationsLabel.lineBreakMode = .byWordWrapping
        indicationsLabel.text = currentDirective!.indications
        indicationsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(indicationsLabel)
        
        let contraTitleLabel = UILabel()
        contraTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        contraTitleLabel.text = "Contraindications:"
        contraTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(contraTitleLabel)
        
        let contraindicationsLabel = UILabel()
        contraindicationsLabel.font = UIFont(name: "HelveticaNeue", size: 14)
        contraindicationsLabel.numberOfLines = 0
        contraindicationsLabel.lineBreakMode = .byWordWrapping
        contraindicationsLabel.text = currentDirective!.contraindications
        contraindicationsLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(contraindicationsLabel)
        
        let treatmentTitleLabel = UILabel()
        treatmentTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        treatmentTitleLabel.text = "Treatment:"
        treatmentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(treatmentTitleLabel)
        
        if(currentDirective!.treatment != "")
        {
            let treatmentLabel = UILabel()
            treatmentLabel.font = UIFont(name: "HelveticaNeue", size: 14)
            treatmentLabel.numberOfLines = 0
            treatmentLabel.lineBreakMode = .byWordWrapping
            treatmentLabel.text = currentDirective!.treatment
            treatmentLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(treatmentLabel)
        }
        
        for drugCard in currentDirective!.drugCards
        {
            let directiveView = MedicalDirectiveView()
            directiveView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(directiveView)
            
            directiveView.treatmentNameOutlet.text = drugCard.title
            directiveView.treatmentDoseOutlet.text = drugCard.doseInformation
            directiveView.notesLabel.text = drugCard.notes
            if(drugCard.targetDrug != "")
            {
                directiveView.drugKey = drugCard.targetDrug
            }
            else
            {
                directiveView.drugKey = ""
                directiveView.drugButton.isEnabled = false
            }
            
            
            switch(drugCard.levelOfCare)
            {
            case "pcp":
                directiveView.patchLabel?.text = "PCP(f)"
                directiveView.patchButton.backgroundColor = pcpColor
            case "acp":
                directiveView.patchLabel?.text = "ACP(f)"
                directiveView.patchButton.backgroundColor = acpColor
            case "ccp":
                directiveView.patchLabel?.text = "CCP"
                directiveView.patchButton.backgroundColor = ccpColor

            default:
                directiveView.patchLabel?.text = "Invalid"
                directiveView.patchButton.backgroundColor = UIColor.darkGray
            }
            
            switch(drugCard.patchPointType)
            {
            case "none":
                directiveView.LOCLabel?.text = "No Patch Required"
                directiveView.levelOfCareButton.backgroundColor = noPatchColor
            case "after":
                directiveView.LOCLabel?.text = "Initiate Then Patch"
                directiveView.levelOfCareButton.backgroundColor = patchAfterColor
            case "first":
                directiveView.LOCLabel?.text = "Mandatory Patch"
                directiveView.levelOfCareButton.backgroundColor = patchFirstColor

            default:
                directiveView.LOCLabel?.text = "Invalid"
                directiveView.levelOfCareButton.backgroundColor = UIColor.darkGray
            }
        }
        if(currentDirective?.clinical != "")
        {
            let clinical = UILabel()
            clinical.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            clinical.numberOfLines = 0
            clinical.lineBreakMode = .byWordWrapping
            clinical.text = "Clinical Considerations/Notes:"
            let clinicalText = UILabel()
            clinicalText.font = UIFont(name: "HelveticaNeue", size: 14)
            clinicalText.numberOfLines = 0
            clinicalText.lineBreakMode = .byWordWrapping
            clinicalText.text = currentDirective!.clinical
            clinical.translatesAutoresizingMaskIntoConstraints = false
            clinicalText.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(clinical)
            stackView.addArrangedSubview(clinicalText)
        }
    }
}
