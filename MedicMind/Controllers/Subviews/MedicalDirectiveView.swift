//
//  Medicalswift
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
let acplColor = UIColor(hex: "#de6276ff")
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
    
    var font : UIFont!

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
    
    @IBAction func drugLinkButton(_ sender: TreatmentCardButton) {
        DrugMonographViewController.loadViewControllerWithKey(key: drugKey)
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
        font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))

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
        
        contentView.backgroundColor = UIColor.clear
        
        treatmentView.layer.borderColor = UIColor.systemGray3.cgColor
        treatmentView.layer.borderWidth = 1
    }
    
    convenience init(_ directive : TreatmentCard) {
        self.init(frame: .zero)
        initDrugCard(directive)
    }
    
    
    
    func initDrugCard(_ directive : TreatmentCard) {
        var levelOfCare : [[String]]
        var doseRoute : [[String]]
        
        if let drug = DataManager.instance.drugByKey(key: directive.drugKey),
            let treatmentInfo = DataManager.instance.treatmentDataByKey(in: drug, key: directive.treatmentKey) {
            levelOfCare = treatmentInfo.loc
            doseRoute = treatmentInfo.dose_route
        }
        else {
            levelOfCare = directive.loc
            doseRoute = directive.dose_route
        }
        
        sectionLabel.attributedText = directive.section.set(style: styleGroup)
        sectionLabel.numberOfLines = 0
        sectionLabel.lineBreakMode = .byWordWrapping

        var titleString = directive.title
        var backgroundColor = UIColor(named: "Secondary_background")!
        if(titleString.hasPrefix("<bg=") && titleString.count > 12)
        {
           titleString.removeFirst(4)
           backgroundColor = UIColor(hexString: titleString.substring(from: 0, length: 9)!)
           titleString.removeFirst(9)
        }

        let attString = directive.title.set(style: styleGroup)
        treatmentNameOutlet.attributedText = attString
        treatmentNameOutlet.textAlignment = .center
                   
        titleStack.addBackground(color: backgroundColor, outlineColor: UIColor.systemGray3)


        if(directive.drugKey != "" && DataManager.instance.drugByKey(key: directive.drugKey) != nil) {
           drugKey = directive.drugKey
        } else {
           drugKey = ""
           drugButton.removeFromSuperview()
        }

        if(directive.calculator.count > 0) {
           targetDrugTables = directive.calculator
        } else {
           calculatorButton.removeFromSuperview()
        }

        if(directive.title == "")
        {
           for view in titleStack.arrangedSubviews
           {
               view.removeFromSuperview()
           }
        }

        let treatmentStack = UIStackView()
        treatmentStack.axis = .vertical
        treatmentStack.alignment = .fill
        treatmentStack.distribution = .fill
        treatmentStack.spacing = 0

        treatmentView.addSubview(treatmentStack)
        treatmentStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
           treatmentStack.leadingAnchor.constraint(equalTo: treatmentView.leadingAnchor),
           treatmentStack.trailingAnchor.constraint(equalTo: treatmentView.trailingAnchor),
           treatmentStack.topAnchor.constraint(equalTo: treatmentView.topAnchor),
           treatmentStack.bottomAnchor.constraint(equalTo: treatmentView.bottomAnchor)
        ])

        notesLabel.attributedText = directive.notes.set(style: styleGroup)
        treatmentView.backgroundColor = UIColor.secondarySystemBackground
               
        
        if(levelOfCare[0][0] != "nil") {
        NSLayoutConstraint.activate([locPatchStack.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(levelOfCare.count) * 120)])
            for locVersion in levelOfCare {
                let locButton = UIButton()
                locButton.backgroundColor = pcpColor
                locButton.isUserInteractionEnabled = false
                let patchPointButton = UIButton()
                patchPointButton.backgroundColor = noPatchColor
                patchPointButton.isUserInteractionEnabled = false

                NSLayoutConstraint.activate([
                    locButton.widthAnchor.constraint(equalToConstant: 25),
                    patchPointButton.widthAnchor.constraint(equalToConstant: 25),
                ])
                
                let stack = UIStackView()
                stack.axis = .horizontal
                stack.translatesAutoresizingMaskIntoConstraints = false
                stack.addArrangedSubview(locButton)
                stack.addArrangedSubview(patchPointButton)
                locPatchStack.addArrangedSubview(stack)
                
                
                //MARK: Patch and LOC buttons
                let locLabel = UILabel(frame: CGRect(x: -41.5, y: 41.5, width: 110, height: 25))
                locLabel.translatesAutoresizingMaskIntoConstraints = false
                locLabel.font = .boldSystemFont(ofSize: CGFloat(11.0))
                locLabel.textAlignment = .center
                locLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2));
                locLabel.textColor = .black
                
                let patchLabel = UILabel(frame: CGRect(x: -41.5, y: 41.5, width: 110, height: 25))
                patchLabel.translatesAutoresizingMaskIntoConstraints = false
                patchLabel.font = .boldSystemFont(ofSize: CGFloat(11.0))
                patchLabel.textAlignment = .center
                patchLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2));
                patchLabel.textColor = .black
                
                stack.addSubview(locLabel)
                stack.addSubview(patchLabel)

                if(locVersion[0] == "pcp") {
                    locButton.backgroundColor = pcpColor
                    locLabel.text = "≥PCP(f)"
                }  else if(locVersion[0] == "acpl") {
                   locButton.backgroundColor = acplColor
                   locLabel.text = "≥ACP(l)"
               }else if(locVersion[0] == "acp") {
                    locButton.backgroundColor = acpColor
                    locLabel.text = "≥ACP(f)"
                } else if(locVersion[0] == "ccp") {
                    locButton.backgroundColor = ccpColor
                    locLabel.text = "CCP(f)"
                } else if(locVersion[0] == "pccp") {
                    locButton.backgroundColor = pccpColor
                    locLabel.text = "PCCP/PCCN"
                } else if(locVersion[0] == "pccn") {
                    locButton.backgroundColor = pccpColor
                    locLabel.text = "PCCN"
                }

                if(locVersion[1] == "none") {
                    patchPointButton.backgroundColor = noPatchColor
                    patchLabel.text = "No Patch Required"
                } else if(locVersion[1] == "after") {
                    patchPointButton.backgroundColor = patchAfterColor
                    patchLabel.text = "Initiate Then Patch"
                } else if(locVersion[1] == "first") {
                    patchPointButton.backgroundColor = patchFirstColor
                   patchLabel.text = "Mandatory Patch"
                } else if(locVersion[1] == "blank") {
                    patchPointButton.backgroundColor = .white
                    patchLabel.text = "Intentionally left Blank"
                    patchLabel.textColor = .systemGray
                }
                                    
                NSLayoutConstraint.activate([
                    patchLabel.centerYAnchor.constraint(equalTo: patchPointButton.centerYAnchor),
                    locLabel.centerYAnchor.constraint(equalTo: locButton.centerYAnchor),
                    patchLabel.centerXAnchor.constraint(equalTo: patchPointButton.centerXAnchor),
                    locLabel.centerXAnchor.constraint(equalTo: locButton.centerXAnchor)
                ])

                patchPointButton.layer.borderWidth = 0.5
                patchPointButton.layer.borderColor = UIColor.systemGray3.cgColor

                locButton.layer.borderWidth = 0.5
                locButton.layer.borderColor = UIColor.systemGray3.cgColor
            }
        } else {
            NSLayoutConstraint.deactivate([locPatchStackWidthConstraint])
            NSLayoutConstraint.activate([locPatchStack.widthAnchor.constraint(equalToConstant: 0.0)])
        }
        
        //MARK: DoseRoute
        var viewArray : [[UIView]] = []
        
        for y in 0 ..< doseRoute.count {
            let contentHStack = UIStackView()
            contentHStack.axis = .horizontal
            contentHStack.distribution = .fillEqually
            contentHStack.spacing = 0
            contentHStack.translatesAutoresizingMaskIntoConstraints = false
            
            if( y % 2 == 0 ) {
                contentHStack.addBackground(color: .tertiarySystemBackground)
            }
            treatmentStack.addArrangedSubview(contentHStack)
            viewArray.append([])
            
            for x in 0 ..< doseRoute[y].count {

                var labelString = doseRoute[y][x]
                var backgroundColor = UIColor(named: "Tertiary_background")
                if(labelString.hasPrefix("<bg=") && labelString.count > 12)
                {
                    labelString.removeFirst(4)
                    backgroundColor = UIColor(hexString: labelString.substring(from: 0, length: 9)!)
                    labelString.removeFirst(9)
                }
                
                let labelView = UIView()
                labelView.layer.borderWidth = 0.5
                labelView.layer.borderColor = UIColor.systemGray3.cgColor
                labelView.backgroundColor = backgroundColor
                    
                let contentLabel = UITextView()
                contentLabel.font = font
                contentLabel.isEditable = false
                contentLabel.isScrollEnabled = false
                contentLabel.delegate = self
                contentLabel.textAlignment = .center
                contentLabel.attributedText = doseRoute[y][x].set(style: styleGroup)
                contentLabel.translatesAutoresizingMaskIntoConstraints = false
                contentLabel.backgroundColor = .clear
               
                labelView.addSubview(contentLabel)
                contentHStack.addArrangedSubview(labelView)

                NSLayoutConstraint.activate([
                    contentLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                    contentLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                    contentLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
                    labelView.heightAnchor.constraint(greaterThanOrEqualTo: contentLabel.heightAnchor)
                ])
                if(viewArray.count > 1 && doseRoute[y].count == doseRoute[y-1].count) {
                    NSLayoutConstraint.activate([
                        labelView.leadingAnchor.constraint(equalTo: viewArray[viewArray.count-2][x].leadingAnchor),
                        labelView.trailingAnchor.constraint(equalTo: viewArray[viewArray.count-2][x].trailingAnchor)
                    ])
                }
                viewArray[viewArray.count-1].append(labelView)
            }
        }
    }
}

extension MedicalDirectiveView : UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("Clicked a link")
        var targetString = URL.absoluteString
        if(targetString.hasPrefix("drugKey=")) {
            targetString = String(targetString.dropFirst(8))
            DrugMonographViewController.loadViewControllerWithKey(key: targetString)
        } else if(targetString.hasPrefix("directive=")) {
            targetString = String(targetString.dropFirst(10))
            MedicalDirectiveTabViewController.loadViewControllerWithKey(key: targetString)
        }
        return false
    }
}


