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

class MedicalDirectiveViewController : UIViewController
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
        
        
        if(currentDirective!.indications != "") {
            let indicationsLabel = makeBodyLabelWithHeader("Indications", bodyText: currentDirective!.indications)
            stackView.addArrangedSubview(indicationsLabel)
        }
        
        if(currentDirective!.contraindications != "") {
            let contraLabel = makeBodyLabelWithHeader("Contraindications", bodyText: currentDirective!.contraindications)
            stackView.addArrangedSubview(contraLabel)
        }
        
        if(currentDirective!.treatment != "") {
            let treatmentLabel = makeBodyLabelWithHeader("Treatment", bodyText: currentDirective!.treatment)
            stackView.addArrangedSubview(treatmentLabel)
        }
        //MARK: Drug cards
        for drugCard in currentDirective!.drugCards
        {
            let directiveView = MedicalDirectiveView(drugCard)
            stackView.addArrangedSubview(directiveView)
            treatmentCards.append(directiveView)
            
            directiveView.notesButton.addTarget(self, action: #selector(noteButtonAction), for: .touchUpInside)
            
        }
            
        //MARK: Clinical considerations
        if(currentDirective?.clinical != "")
        {
            let clinicalLabel = makeBodyLabelWithHeader("Clinical Considerations/Notes", bodyText: currentDirective!.clinical)
            stackView.addArrangedSubview(clinicalLabel)
        }
        
    }
    
    func makeBodyLabelWithHeader(_ title : String, bodyText : String) -> UITextView
    {
        let outputLabel = UITextView()
        let combinedString = String("<title>" + title + "</title>\n" + bodyText).set(style: styleGroup)

        outputLabel.attributedText = combinedString
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.isScrollEnabled = false
        outputLabel.isEditable = false
        outputLabel.delegate = self
        outputLabel.isSelectable = true
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

extension MedicalDirectiveViewController : UITextViewDelegate
{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        var targetString = URL.absoluteString
        if(targetString.hasPrefix("drugKey=")) {
            targetString = String(targetString.dropFirst(8))
            DrugMonographViewController.loadViewControllerWithKey(key: targetString)
        }
        return false
    }
    
}
