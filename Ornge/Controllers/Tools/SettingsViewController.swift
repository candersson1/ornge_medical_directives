//
//  SettingsViewController.swift
//  MedicMind
//
//  Created by Charles Trickey on 2019-06-17.
//  Copyright © 2019 Charles Trickey. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SettingsViewController : UIViewController
{
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var publicDeviceSwitch: UISwitch!
    @IBOutlet weak var publicDeviceLabel: UILabel!
    
    @IBAction func fontSliderAction(_ sender: Any) {
        fontSizeSlider.value = Float(Int(fontSizeSlider.value))
        
        DataManager.instance.fontSize = fontSizeSlider.value
        normalStyle.font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        titleStyle.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize + 3))
        boldStyle.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        italicStyle.font = UIFont.italicSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        linkStyle.font = UIFont.systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        boldItalicStyle.font = UIFont.boldSystemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        
        updateFont()
        UserDefaults.standard.set(fontSizeSlider.value, forKey: "font_size")
    }
    
    @IBAction func publicDeviceSwitcherAction(_ sender: UISwitch) {
        
        if(sender.isOn) {
            let alert = UIAlertController(title: "Set Device to Public", message: "By setting this device to public, you will remove all personal notes from the device. This cannot be undone.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "No", style: .cancel) {
                _ in
                sender.isOn = false
            })
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive) {
                _ in
                
                self.deleteAllNotes()
            })

            self.present(alert, animated: true)
        }
        
        DataManager.instance.publicDevice = sender.isOn
        UserDefaults.standard.set(self.publicDeviceSwitch.isOn, forKey: "public_device")
    
        
    }
    
    func deleteAllNotes() {
        // Create Fetch Request
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")

        var notesArray : [Note] = []
        
        do {
            notesArray = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        for note in notesArray {
            context.delete(note)
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving context with \(error)")
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let titleView = UILabel()
        titleView.text = "Settings"
        titleView.textColor = .white
        titleView.font = .boldSystemFont(ofSize: 17)
        titleView.lineBreakMode = .byWordWrapping
        titleView.numberOfLines = 0
        self.navigationItem.titleView = titleView
        
        fontSizeSlider.value = DataManager.instance.fontSize
        fontSizeLabel.text = "Font Size: \(fontSizeSlider.value)"
        updateFont()
        
        publicDeviceSwitch.isOn = DataManager.instance.publicDevice
    }
    
    func updateFont()
    {
        fontSizeLabel.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
        fontSizeLabel.text = "Font Size: \(fontSizeSlider.value)"
        publicDeviceLabel.font = .systemFont(ofSize: CGFloat(DataManager.instance.fontSize))
    }
}
