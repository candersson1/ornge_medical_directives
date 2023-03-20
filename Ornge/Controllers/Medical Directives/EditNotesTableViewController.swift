//
//  EditNotesTableViewController.swift
//  OntarioMedic
//
//  Created by Charles Trickey on 2019-07-27.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import UIKit
import CoreData

class TableViewTextView : UITextView
{
    var Index : IndexPath?
}

class EditNotesTableViewCell : UITableViewCell
{
    @IBOutlet weak var textview: TableViewTextView!
    
}

class EditNotesTableViewController: UITableViewController, UITextViewDelegate {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var key : String = ""
    var notes : [Note] = []
    
    @objc func addButtonTapped()
    {
        let note = Note(context: self.context)
        note.text = "New note"
        note.key = key
        notes.append(note)
        tableView.reloadData()
        saveNotes()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNotes(key: key)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:  #selector(addButtonTapped))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadNotes(key: key)
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveNotes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> EditNotesTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editNotesCell", for: indexPath) as! EditNotesTableViewCell
        
        cell.textview.text = notes[indexPath.row].text
        cell.textview.Index = indexPath
        cell.textview.delegate = self
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = self.view.frame.size.width - 10
        if let cell = tableView.cellForRow(at: indexPath) as? EditNotesTableViewCell
        {
            let calculatedHeight = cell.textview.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT))).height + 20
            return calculatedHeight
        }
        
        return 50
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        if let tableTextView = (textView as? TableViewTextView)
        {
            notes[tableTextView.Index!.row].text = tableTextView.text
        }
    }
  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            context.delete(notes[indexPath.row])
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveNotes()
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
   
    func loadNotes(key : String)
    {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "key == %@", key)
        request.predicate = predicate
        do {
            notes = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func saveNotes()
    {
        do {
            try context.save()
        } catch {
            print("Error saving context with \(error)")
        }
    }
}
