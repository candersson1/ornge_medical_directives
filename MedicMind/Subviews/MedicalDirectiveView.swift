//
//  MedicalDirectiveView.swift
//  Medic's Little Helper
//
//  Created by Charles Trickey on 2019-05-07.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let directiveHeight = 242
let directiveWidth = 426

let pcpColor = UIColor(hex: "#918b75ff")
let acpColor = UIColor(hex: "#34a8ebff")
let ccpColor = UIColor(hex: "#cdbce0ff")
let pccpColor = UIColor(hex: "#ff96ddff")
let noPatchColor = UIColor(hex: "#9ab898ff")
let patchAfterColor = UIColor(hex: "#fff319ff")
let patchFirstColor = UIColor(hex: "#ff522bff")

class MedicalDirectiveView : UIView
{
    //constraints
    
    @IBOutlet weak var drugButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var calcButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var locPatchStackWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var locPatchStack: UIStackView!
    
    @IBOutlet var contentView: MedicalDirectiveView!
    @IBOutlet weak var treatmentNameOutlet: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var drugButton: UIButton!
    @IBOutlet weak var calculatorButton: UIButton!
    @IBOutlet weak var treatmentView: UIView!
    
    @IBOutlet weak var notesButton: TreatmentCardButton!
    @IBOutlet weak var titleStack: UIStackView!
    @IBOutlet weak var personalNotesStack: UIStackView!
    
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var personalNotesLabel: TreatmentCardButton!
    
    var drugKey : String = ""
    var targetDrugTables : [DrugTable] = []
    
    var patchLabel : UILabel?
    var LOCLabel : UILabel?

    @IBAction func calculatorLinkButton(_ sender: Any) {
        if(targetDrugTables.count > 0)
        {
            let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
            let storyboard = navController?.storyboard
            
            let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugCalculatorViewController") as! DrugCalculatorViewController
            
            viewController.drugTables = targetDrugTables
            navController!.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func drugLinkButton(_ sender: Any) {
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: "DrugMonographViewController") as! DrugMonographViewController
        
        viewController.drugData = DataManager.instance.drugByKey(key: drugKey)
        navController!.pushViewController(viewController, animated: true)
    }
    @IBAction func PersonalNotesTapped(_ sender: TreatmentCardButton) {
        let navController = UIApplication.shared.windows[0].rootViewController as? UINavigationController
        let storyboard = navController?.storyboard
        
        let viewController = storyboard!.instantiateViewController(withIdentifier: "EditNotesViewController") as! EditNotesTableViewController
        
        viewController.key = sender.key
        navController!.pushViewController(viewController, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
        initFonts()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        initFonts()
        notesButton.parentView = self
    }
    
    func initFonts()
    {
        let font = UIFont(name: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize))

        sectionLabel.font = font
        notesLabel.font = font
        treatmentNameOutlet.font = font
        personalNotesLabel.titleLabel!.font = font
        personalNotesLabel.titleLabel!.numberOfLines = 0
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "MedicalDirectiveView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.frame = bounds
        addSubview(contentView)
        personalNotesLabel.useLabelSize = true
        
        /*var t = CGAffineTransform.identity
        t = t.rotated(by: -.pi / 2)
        t = t.translatedBy(x: -40, y: -patchPointButton.frame.size.width * 1.65)
        patchLabel = UILabel(frame: CGRect(x: 0, y: 0, width: patchPointButton.frame.size.height, height: patchPointButton.frame.size.width))
        patchLabel!.transform = t
        patchLabel!.font = UIFont(name: DataManager.instance.boldFontName, size: 10)
        patchLabel!.text = "Initiate Then Patch"
        patchLabel!.textAlignment = .center
        patchLabel!.textColor = UIColor.black
        patchPointButton.addSubview(patchLabel!)
        
        t = CGAffineTransform.identity
        t = t.rotated(by: -.pi / 2)
        t = t.translatedBy(x: -40, y: -patchPointButton.frame.size.width*1.65)
        LOCLabel = UILabel(frame: CGRect(x: 0, y: 0, width: locButton.frame.size.height, height: locButton.frame.size.width))
        LOCLabel!.transform = t
        LOCLabel!.font = UIFont(name: DataManager.instance.boldFontName, size: 10)
        LOCLabel!.textAlignment = .center
        LOCLabel!.text = "ACP(f)"
        LOCLabel!.textColor = UIColor.black

        locButton.addSubview(LOCLabel!)
        patchPointButton.layer.borderColor = UIColor.systemGray3.cgColor
        patchPointButton.layer.borderWidth = 1
        locButton.layer.borderColor = UIColor.systemGray3.cgColor
        locButton.layer.borderWidth = 1
        */
        contentView.backgroundColor = UIColor.systemBackground
        
        treatmentView.layer.borderColor = UIColor.systemGray3.cgColor
        treatmentView.layer.borderWidth = 1
    }
}


