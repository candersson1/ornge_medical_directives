//
//  MedicalDirectiveViewController.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-05-13.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SwiftRichString

class MedicalDirectiveViewController : UIViewController, UITextViewDelegate
{
    @IBOutlet weak var scrollView: UIScrollView!
    var currentDirective : MedicalDirective?
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var treatmentCards : [MedicalDirectiveView] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadNotesLabels()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground

        let font = UIFont(name: DataManager.instance.fontName, size: CGFloat(DataManager.instance.fontSize))
        let boldFont = UIFont(name: DataManager.instance.boldFontName, size: CGFloat(DataManager.instance.fontSize))
        
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
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: DataManager.instance.boldFontName, size: CGFloat(20.0))
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.text = currentDirective?.title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.label//accentColor
        stackView.addArrangedSubview(titleLabel)
        
        
        if(currentDirective!.indications != "")
        {
            let indicationsLabel = makeBodyLabelWithHeader("Indications", bodyText: currentDirective!.indications)
            stackView.addArrangedSubview(indicationsLabel)
            
        }
        
        if(currentDirective!.contraindications != "")
        {
            let contraLabel = makeBodyLabelWithHeader("Contraindications", bodyText: currentDirective!.contraindications)
            stackView.addArrangedSubview(contraLabel)
            
        }
        
        if(currentDirective!.treatment != "")
        {
            let treatmentLabel = makeBodyLabelWithHeader("Treatment", bodyText: currentDirective!.treatment)
            stackView.addArrangedSubview(treatmentLabel)
        }
        //MARK: Drug cards
        var index = 0
        for drugCard in currentDirective!.drugCards
        {
            let directiveView = MedicalDirectiveView()
            stackView.addArrangedSubview(directiveView)
            directiveView.translatesAutoresizingMaskIntoConstraints = false
            directiveView.personalNotesStack.translatesAutoresizingMaskIntoConstraints = false
            treatmentCards.append(directiveView)
            
            directiveView.locPatchStack.translatesAutoresizingMaskIntoConstraints = false
            
            var levelOfCare : [[String]]
            var doseRoute : [[String]]
            if let drug = DataManager.instance.drugByKey(key: drugCard.drugKey),
                let treatmentInfo = DataManager.instance.treatmentDataByKey(in: drug, key: drugCard.treatmentKey) {
                levelOfCare = treatmentInfo.loc
                doseRoute = treatmentInfo.dose_route
            }
            else {
                levelOfCare = drugCard.loc
                doseRoute = drugCard.dose_route
            }
            
            if(levelOfCare[0][0] != "nil") {
            NSLayoutConstraint.activate([directiveView.locPatchStack.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(levelOfCare.count) * 110)])
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
                    directiveView.locPatchStack.addArrangedSubview(stack)
                    
                    
                    //MARK: Patch and LOC buttons
                    let locLabel = UILabel(frame: CGRect(x: -41.5, y: 41.5, width: 110, height: 25))
                    locLabel.translatesAutoresizingMaskIntoConstraints = false
                    locLabel.font = UIFont(name: DataManager.instance.boldFontName, size: 11)
                    locLabel.textAlignment = .center
                    locLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2));
                    locLabel.textColor = .black
                    
                    let patchLabel = UILabel(frame: CGRect(x: -41.5, y: 41.5, width: 110, height: 25))
                    patchLabel.translatesAutoresizingMaskIntoConstraints = false
                    patchLabel.font = UIFont(name: DataManager.instance.boldFontName, size: 11)
                    patchLabel.textAlignment = .center
                    patchLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2));
                    patchLabel.textColor = .black
                    
                    stack.addSubview(locLabel)
                    stack.addSubview(patchLabel)

                    if(locVersion[0] == "pcp") {
                        locButton.backgroundColor = pcpColor
                        locLabel.text = "≥PCP(f)"
                    } else if(locVersion[0] == "acp") {
                        locButton.backgroundColor = acpColor
                        locLabel.text = "≥ACP(f)"
                    } else if(locVersion[0] == "ccp") {
                        locButton.backgroundColor = ccpColor
                        locLabel.text = "CCP(f)"
                    } else if(locVersion[0] == "pccp") {
                        locButton.backgroundColor = pccpColor
                        locLabel.text = "PCCP(f)"
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
                NSLayoutConstraint.deactivate([directiveView.locPatchStackWidthConstraint])
                NSLayoutConstraint.activate([directiveView.locPatchStack.widthAnchor.constraint(equalToConstant: 0.0)])
            }
            
            directiveView.sectionLabel.attributedText = drugCard.section.set(style: styleGroup)
            directiveView.sectionLabel.numberOfLines = 0
            directiveView.sectionLabel.lineBreakMode = .byWordWrapping
            
            directiveView.treatmentNameOutlet.attributedText = drugCard.title.set(style: styleGroup)
            directiveView.treatmentNameOutlet.textAlignment = .center
            
            directiveView.titleStack.addBackground(color: UIColor.secondarySystemBackground, outlineColor: UIColor.systemGray3)
            //directiveView.treatmentNameOutlet.textColor = UIColor.label
            
            if(drugCard.drugKey != "" && DataManager.instance.drugByKey(key: drugCard.drugKey) != nil) {
                directiveView.drugKey = drugCard.drugKey
            } else {
                directiveView.drugKey = ""
                directiveView.drugButton.removeFromSuperview()
            }
            
            if(drugCard.calculator.count > 0) {
                directiveView.targetDrugTables = drugCard.calculator
            } else {
                directiveView.calculatorButton.removeFromSuperview()
            }
            
            if(drugCard.title == "")
            {
                for view in directiveView.titleStack.arrangedSubviews
                {
                    view.removeFromSuperview()
                }
            }
            
            let treatmentStack = UIStackView()
            treatmentStack.axis = .vertical
            treatmentStack.alignment = .fill
            treatmentStack.distribution = .fill
            treatmentStack.spacing = 0
     
            directiveView.treatmentView.addSubview(treatmentStack)
            treatmentStack.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                treatmentStack.leadingAnchor.constraint(equalTo: directiveView.treatmentView.leadingAnchor),
                treatmentStack.trailingAnchor.constraint(equalTo: directiveView.treatmentView.trailingAnchor),
                treatmentStack.topAnchor.constraint(equalTo: directiveView.treatmentView.topAnchor),
                treatmentStack.bottomAnchor.constraint(equalTo: directiveView.treatmentView.bottomAnchor)
            ])
            
            directiveView.notesLabel.attributedText = drugCard.notes.set(style: styleGroup)
            directiveView.treatmentView.backgroundColor = UIColor.secondarySystemBackground
            
            //MARK: DoseRoute
            if(doseRoute.count > 0)
            {
                var stackCollection : [UIStackView] = []
            
                for i in 0 ..< doseRoute[0].count
                {
                    let doseHStack = UIStackView()
                    doseHStack.axis = .horizontal
                    doseHStack.alignment = .fill
                    doseHStack.distribution = .fillEqually
                    doseHStack.spacing = 0
                    doseHStack.translatesAutoresizingMaskIntoConstraints = false
                    
                    if( i % 2 == 1)
                    {
                        doseHStack.addBackground(color: UIColor.tertiarySystemBackground)
                    }
                    treatmentStack.addArrangedSubview(doseHStack)
                    stackCollection.append(doseHStack)
                }
                
                for i in 0 ..< doseRoute.count
                {
                    let doseArray = doseRoute[i]
                    var labelArray : [UILabel] = []
                    
                    if( doseArray[0] != "nil" )
                    {
                        for j in 0 ..< doseArray.count
                        {
                            if( j >= stackCollection.count )
                            {
                                print("Missmatch between doseArray and stackCollection, ensure that all dose_route arrays have equal number of values")
                                break
                            }
                            if(doseArray[j] != "nil")
                            {
                            let labelView = UIView()
                            labelView.layer.borderWidth = 0.5
                            labelView.layer.borderColor = UIColor.systemGray3.cgColor
                            
                            let doseLabel = UILabel()
                            doseLabel.font = font
                            doseLabel.lineBreakMode = .byWordWrapping
                            doseLabel.numberOfLines = 0
                            doseLabel.attributedText = doseArray[j].set(style: styleGroup)
                            doseLabel.translatesAutoresizingMaskIntoConstraints = false
                            
                            labelArray.append(doseLabel)
                            labelView.addSubview(doseLabel)
                            
                            NSLayoutConstraint.activate([
                                doseLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
                                doseLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
                                doseLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
                                doseLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5)
                            ])
                            
                            stackCollection[j].addArrangedSubview(labelView)
                            }
                        }
                    }
                    
                    directiveView.notesButton.addTarget(self, action: #selector(noteButtonAction), for: .touchUpInside)
                    let notesKey = "\(currentDirective!.key)-\(index)"
                    directiveView.notesButton.key = notesKey
                    directiveView.personalNotesLabel.key = notesKey
                    let notesArray = loadNote(key: notesKey)
                    var notesString = ""

                    for note in notesArray
                    {
                        notesString = notesString + "• " + note + "\n"
                    }
                    directiveView.personalNotesLabel.setTitle(notesString, for: .normal)

                    index += 1
                }
            }
        }
        //MARK: Clinical considerations
        if(currentDirective?.clinical != "")
        {
            let clinicalLabel = makeBodyLabelWithHeader("Clinical Considerations/Notes", bodyText: currentDirective!.clinical)
            stackView.addArrangedSubview(clinicalLabel)
        }
    }
    
    func makeBodyLabelWithHeader(_ title : String, bodyText : String) -> UILabel
    {
        let outputLabel = UILabel()
        let combinedString = String("<title>" + title + "</title>\n" + bodyText).set(style: styleGroup)
        outputLabel.attributedText = combinedString
        outputLabel.numberOfLines = 0
        outputLabel.lineBreakMode = .byWordWrapping
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.textColor = UIColor.label
        
        return outputLabel
    }
    
    func reloadNotesLabels()
    {
        var index = 0
        for directiveView in treatmentCards
        {
            let notesKey = "\(currentDirective!.key)-\(index)"
            directiveView.notesButton.key = notesKey
            directiveView.personalNotesLabel.key = notesKey
            let notesArray = loadNote(key: notesKey)
            var notesString = ""
            
            for note in notesArray
            {
                notesString = notesString + "• " + note + "\n"
            }
            directiveView.personalNotesLabel.setTitle(notesString, for: .normal)
            index += 1
            
        }
    }
 
    @objc func noteButtonAction(sender : TreatmentCardButton)
    {
        var textfield = UITextField()
    
        let alert = UIAlertController(title: "Add Note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Note", style: .default) {(action) in
            let newNote = Note(context: self.context)
            newNote.text = textfield.text
            newNote.key = sender.key
            sender.parentView!.personalNotesLabel.setTitle(newNote.text, for: .normal)
            sender.parentView!.personalNotesLabel.titleLabel!.textColor = UIColor.blue
            self.saveNotes()
            self.reloadNotesLabels()
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "New note"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveNotes()
    {
        do {
            try context.save()
        } catch {
            print("Error saving context with \(error)")
        }
    }
    
    
    func loadNote(key : String) -> [String]
    {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "key == %@", key)
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            
            if(result.count > 0) {
                var retArray : [String] = []
                for res in result
                {
                    retArray.append(res.text!)
                }
                return retArray
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
        return []
    }
}
