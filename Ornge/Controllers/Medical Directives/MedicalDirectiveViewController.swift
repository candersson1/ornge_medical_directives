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

class MedicalDirectiveViewController : UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rootStackView: UIStackView!
    
    var currentDirective : MedicalDirective?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var treatmentCards : [MedicalDirectiveView] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.delegate = self
        reloadNotesLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: These should be condensed into a single field of attributed text
        if(currentDirective!.indications != "") {
            let indicationsLabel = makeBodyLabelWithHeader("Indications", bodyText: currentDirective!.indications)
            rootStackView.addArrangedSubview(indicationsLabel)
        }
        
        if(currentDirective!.contraindications != "") {
            let contraLabel = makeBodyLabelWithHeader("Contraindications", bodyText: currentDirective!.contraindications)
            rootStackView.addArrangedSubview(contraLabel)
        }
        
        if(currentDirective!.treatment != "") {
            let treatmentLabel = makeBodyLabelWithHeader("Treatment", bodyText: currentDirective!.treatment)
            rootStackView.addArrangedSubview(treatmentLabel)
        }
        //MARK: Drug cards
        for drugCard in currentDirective!.drugCards {
            let directiveView = MedicalDirectiveView(drugCard)
            rootStackView.addArrangedSubview(directiveView)
            treatmentCards.append(directiveView)
            
            if(DataManager.instance.publicDevice) {
                directiveView.notesButton.removeFromSuperview()
            } else {
                directiveView.notesButton.addTarget(self, action: #selector(noteButtonAction), for: .touchUpInside)
            }
        }
            
        //MARK: Clinical considerations
        if(currentDirective?.clinical != "") {
            let clinicalLabel = makeBodyLabelWithHeader("Clinical Considerations/Notes", bodyText: currentDirective!.clinical)
            rootStackView.addArrangedSubview(clinicalLabel)
        }
        
    }
    
    func makeBodyLabelWithHeader(_ title : String, bodyText : String) -> UITextView {
        let outputLabel = UITextView()
        let combinedString = String("<title>" + title + "</title>\n" + bodyText).set(style: styleGroup)

        outputLabel.attributedText = combinedString
        outputLabel.backgroundColor = UIColor(named: "Primary_background")
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        outputLabel.isScrollEnabled = false
        outputLabel.isEditable = false
        outputLabel.delegate = self
        outputLabel.isSelectable = true
        return outputLabel
    }
    
    func reloadNotesLabels()
    {
        if(DataManager.instance.publicDevice != true)
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
            sender.parentView!.personalNotesLabel.titleLabel!.textColor = UIColor.systemBlue
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
        print("Clicked a link")
        var targetString = URL.absoluteString
        print("Target String", targetString)
        if(targetString.hasPrefix("drugKey=")) {
            targetString = String(targetString.dropFirst(8))
            DrugMonographViewController.loadViewControllerWithKey(key: targetString)
        } else if(targetString.hasPrefix("webview=")) {
            targetString = String(targetString.dropFirst(8))
            let webViewController = WebViewController()
            // If you want to set some properties
            //webViewController.colour = "Red"
            webViewController.target = targetString
            // And then you push it into the navigation controller
            self.navigationController?.pushViewController(webViewController, animated: true)
            
           
        }
        return false
    }
    
}

extension MedicalDirectiveViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return rootStackView
    }
}
